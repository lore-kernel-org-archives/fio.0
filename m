Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Wed, 24 Feb 2016 19:32:34 +0300
Message-ID: <CANvN+emV7MN2HXt-Lzm_AhdiFgV34z_v2kWbvsbW0q2o7N3vdA@mail.gmail.com>
Subject: [PATCH v2]: Let I/O engine provide methods to allocate/free I/O memory.
Content-Type: multipart/mixed; boundary=001a11c33f8025f50d052c869e7b
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--001a11c33f8025f50d052c869e7b
Content-Type: text/plain; charset=UTF-8

The patch has been revised to add 'mem=ioengine' option and respective
sanity checks.

Regards,
Andrey


diff --git a/HOWTO b/HOWTO
index 5e765d4..c2243b5 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1195,6 +1195,10 @@ mem=str        Fio can use various types of
memory as the io unit buffer.

             mmapshared    Same as mmap, but use a MMAP_SHARED
                 mapping.
+            ioengine    I/O engine provides iomem_alloc/free
+                entries to allocate and free I/O memory.
+                The engine is then responsible for the memory
+                type compatibility with other job settings.

         The area allocated is a function of the maximum allowed
         bs size for the job, multiplied by the io depth given. Note
diff --git a/ioengine.h b/ioengine.h
index 6734c7b..161acf5 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -16,7 +16,7 @@
 #include <guasi.h>
 #endif

-#define FIO_IOOPS_VERSION    22
+#define FIO_IOOPS_VERSION    23

 enum {
     IO_U_F_FREE        = 1 << 0,
@@ -157,6 +157,8 @@ struct ioengine_ops {
     int (*unlink_file)(struct thread_data *, struct fio_file *);
     int (*get_file_size)(struct thread_data *, struct fio_file *);
     void (*terminate)(struct thread_data *);
+    int (*iomem_alloc)(struct thread_data *, size_t);
+    void (*iomem_free)(struct thread_data *);
     int (*io_u_init)(struct thread_data *, struct io_u *);
     void (*io_u_free)(struct thread_data *, struct io_u *);
     int option_struct_size;
diff --git a/ioengines.c b/ioengines.c
index decc9cb..9ef3395 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -22,7 +22,7 @@

 static FLIST_HEAD(engine_list);

-static int check_engine_ops(struct ioengine_ops *ops)
+static int check_engine_ops(struct thread_options *o, struct ioengine_ops *ops)
 {
     if (ops->version != FIO_IOOPS_VERSION) {
         log_err("bad ioops version %d (want %d)\n", ops->version,
@@ -35,6 +35,20 @@ static int check_engine_ops(struct ioengine_ops *ops)
         return 1;
     }

+    if (o->mem_type == MEM_IOENGINE &&
+         !(ops->iomem_alloc && ops->iomem_free)) {
+        log_err("%s: iomem handler(s) missing when "
+            "iomem=ioengine\n", ops->name);
+        return 1;
+    }
+
+    if (o->mem_type != MEM_IOENGINE &&
+        (ops->iomem_alloc || ops->iomem_free)) {
+        log_err("%s: iomem handler(s) present when "
+            "iomem!=ioengine\n", ops->name);
+        return 1;
+    }
+
     /*
      * sync engines only need a ->queue()
      */
@@ -154,7 +168,7 @@ struct ioengine_ops *load_ioengine(struct
thread_data *td, const char *name)
     /*
      * Check that the required methods are there.
      */
-    if (check_engine_ops(ops))
+    if (check_engine_ops(&td->o, ops))
         return NULL;

     ret = malloc(sizeof(*ret));
diff --git a/memory.c b/memory.c
index 5060223..cf9f60a 100644
--- a/memory.c
+++ b/memory.c
@@ -236,6 +236,8 @@ int allocate_io_mem(struct thread_data *td)
     else if (td->o.mem_type == MEM_MMAP || td->o.mem_type == MEM_MMAPHUGE ||
          td->o.mem_type == MEM_MMAPSHARED)
         ret = alloc_mem_mmap(td, total_mem);
+    else if (td->o.mem_type == MEM_IOENGINE)
+        ret = td->io_ops->iomem_alloc(td, total_mem);
     else {
         log_err("fio: bad mem type: %d\n", td->o.mem_type);
         ret = 1;
@@ -262,6 +264,8 @@ void free_io_mem(struct thread_data *td)
     else if (td->o.mem_type == MEM_MMAP || td->o.mem_type == MEM_MMAPHUGE ||
          td->o.mem_type == MEM_MMAPSHARED)
         free_mem_mmap(td, total_mem);
+    else if (td->o.mem_type == MEM_IOENGINE)
+        td->io_ops->iomem_free(td);
     else
         log_err("Bad memory type %u\n", td->o.mem_type);

diff --git a/options.c b/options.c
index 3902087..28a8fca 100644
--- a/options.c
+++ b/options.c
@@ -2100,6 +2100,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
                 .help = "Like mmap, but use huge pages",
               },
 #endif
+              { .ival = "ioengine",
+                .oval = MEM_IOENGINE,
+                .help = "I/O engine provides alloc/free methods",
+              },
           },
     },
     {
diff --git a/thread_options.h b/thread_options.h
index 384534a..98fafa3 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -20,6 +20,7 @@ enum fio_memtype {
     MEM_MMAP,    /* use anonynomous mmap */
     MEM_MMAPHUGE,    /* memory mapped huge file */
     MEM_MMAPSHARED, /* use mmap with shared flag */
+    MEM_IOENGINE,    /* managed by I/O engine */
 };

 #define ERROR_STR_MAX    128

--001a11c33f8025f50d052c869e7b
Content-Type: text/x-patch; charset=US-ASCII; name="Let-io-engine-allocate-io-memory.patch"
Content-Disposition: attachment; 
	filename="Let-io-engine-allocate-io-memory.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_il1250s91

ZGlmZiAtLWdpdCBhL0hPV1RPIGIvSE9XVE8KaW5kZXggNWU3NjVkNC4uYzIyNDNiNSAxMDA2NDQK
LS0tIGEvSE9XVE8KKysrIGIvSE9XVE8KQEAgLTExOTUsNiArMTE5NSwxMCBAQCBtZW09c3RyCQlG
aW8gY2FuIHVzZSB2YXJpb3VzIHR5cGVzIG9mIG1lbW9yeSBhcyB0aGUgaW8gdW5pdCBidWZmZXIu
CiAKIAkJCW1tYXBzaGFyZWQJU2FtZSBhcyBtbWFwLCBidXQgdXNlIGEgTU1BUF9TSEFSRUQKIAkJ
CQltYXBwaW5nLgorCQkJaW9lbmdpbmUJSS9PIGVuZ2luZSBwcm92aWRlcyBpb21lbV9hbGxvYy9m
cmVlCisJCQkJZW50cmllcyB0byBhbGxvY2F0ZSBhbmQgZnJlZSBJL08gbWVtb3J5LgorCQkJCVRo
ZSBlbmdpbmUgaXMgdGhlbiByZXNwb25zaWJsZSBmb3IgdGhlIG1lbW9yeSAKKwkJCQl0eXBlIGNv
bXBhdGliaWxpdHkgd2l0aCBvdGhlciBqb2Igc2V0dGluZ3MuCiAKIAkJVGhlIGFyZWEgYWxsb2Nh
dGVkIGlzIGEgZnVuY3Rpb24gb2YgdGhlIG1heGltdW0gYWxsb3dlZAogCQlicyBzaXplIGZvciB0
aGUgam9iLCBtdWx0aXBsaWVkIGJ5IHRoZSBpbyBkZXB0aCBnaXZlbi4gTm90ZQpkaWZmIC0tZ2l0
IGEvaW9lbmdpbmUuaCBiL2lvZW5naW5lLmgKaW5kZXggNjczNGM3Yi4uMTYxYWNmNSAxMDA2NDQK
LS0tIGEvaW9lbmdpbmUuaAorKysgYi9pb2VuZ2luZS5oCkBAIC0xNiw3ICsxNiw3IEBACiAjaW5j
bHVkZSA8Z3Vhc2kuaD4KICNlbmRpZgogCi0jZGVmaW5lIEZJT19JT09QU19WRVJTSU9OCTIyCisj
ZGVmaW5lIEZJT19JT09QU19WRVJTSU9OCTIzCiAKIGVudW0gewogCUlPX1VfRl9GUkVFCQk9IDEg
PDwgMCwKQEAgLTE1Nyw2ICsxNTcsOCBAQCBzdHJ1Y3QgaW9lbmdpbmVfb3BzIHsKIAlpbnQgKCp1
bmxpbmtfZmlsZSkoc3RydWN0IHRocmVhZF9kYXRhICosIHN0cnVjdCBmaW9fZmlsZSAqKTsKIAlp
bnQgKCpnZXRfZmlsZV9zaXplKShzdHJ1Y3QgdGhyZWFkX2RhdGEgKiwgc3RydWN0IGZpb19maWxl
ICopOwogCXZvaWQgKCp0ZXJtaW5hdGUpKHN0cnVjdCB0aHJlYWRfZGF0YSAqKTsKKwlpbnQgKCpp
b21lbV9hbGxvYykoc3RydWN0IHRocmVhZF9kYXRhICosIHNpemVfdCk7CisJdm9pZCAoKmlvbWVt
X2ZyZWUpKHN0cnVjdCB0aHJlYWRfZGF0YSAqKTsKIAlpbnQgKCppb191X2luaXQpKHN0cnVjdCB0
aHJlYWRfZGF0YSAqLCBzdHJ1Y3QgaW9fdSAqKTsKIAl2b2lkICgqaW9fdV9mcmVlKShzdHJ1Y3Qg
dGhyZWFkX2RhdGEgKiwgc3RydWN0IGlvX3UgKik7CiAJaW50IG9wdGlvbl9zdHJ1Y3Rfc2l6ZTsK
ZGlmZiAtLWdpdCBhL2lvZW5naW5lcy5jIGIvaW9lbmdpbmVzLmMKaW5kZXggZGVjYzljYi4uOWVm
MzM5NSAxMDA2NDQKLS0tIGEvaW9lbmdpbmVzLmMKKysrIGIvaW9lbmdpbmVzLmMKQEAgLTIyLDcg
KzIyLDcgQEAKIAogc3RhdGljIEZMSVNUX0hFQUQoZW5naW5lX2xpc3QpOwogCi1zdGF0aWMgaW50
IGNoZWNrX2VuZ2luZV9vcHMoc3RydWN0IGlvZW5naW5lX29wcyAqb3BzKQorc3RhdGljIGludCBj
aGVja19lbmdpbmVfb3BzKHN0cnVjdCB0aHJlYWRfb3B0aW9ucyAqbywgc3RydWN0IGlvZW5naW5l
X29wcyAqb3BzKQogewogCWlmIChvcHMtPnZlcnNpb24gIT0gRklPX0lPT1BTX1ZFUlNJT04pIHsK
IAkJbG9nX2VycigiYmFkIGlvb3BzIHZlcnNpb24gJWQgKHdhbnQgJWQpXG4iLCBvcHMtPnZlcnNp
b24sCkBAIC0zNSw2ICszNSwyMCBAQCBzdGF0aWMgaW50IGNoZWNrX2VuZ2luZV9vcHMoc3RydWN0
IGlvZW5naW5lX29wcyAqb3BzKQogCQlyZXR1cm4gMTsKIAl9CiAKKwlpZiAoby0+bWVtX3R5cGUg
PT0gTUVNX0lPRU5HSU5FICYmCisJICAgICAhKG9wcy0+aW9tZW1fYWxsb2MgJiYgb3BzLT5pb21l
bV9mcmVlKSkgeworCQlsb2dfZXJyKCIlczogaW9tZW0gaGFuZGxlcihzKSBtaXNzaW5nIHdoZW4g
IgorCQkJImlvbWVtPWlvZW5naW5lXG4iLCBvcHMtPm5hbWUpOworCQlyZXR1cm4gMTsKKwl9CisK
KwlpZiAoby0+bWVtX3R5cGUgIT0gTUVNX0lPRU5HSU5FICYmCisJICAgIChvcHMtPmlvbWVtX2Fs
bG9jIHx8IG9wcy0+aW9tZW1fZnJlZSkpIHsKKwkJbG9nX2VycigiJXM6IGlvbWVtIGhhbmRsZXIo
cykgcHJlc2VudCB3aGVuICIKKwkJCSJpb21lbSE9aW9lbmdpbmVcbiIsIG9wcy0+bmFtZSk7CisJ
CXJldHVybiAxOworCX0KKwogCS8qCiAJICogc3luYyBlbmdpbmVzIG9ubHkgbmVlZCBhIC0+cXVl
dWUoKQogCSAqLwpAQCAtMTU0LDcgKzE2OCw3IEBAIHN0cnVjdCBpb2VuZ2luZV9vcHMgKmxvYWRf
aW9lbmdpbmUoc3RydWN0IHRocmVhZF9kYXRhICp0ZCwgY29uc3QgY2hhciAqbmFtZSkKIAkvKgog
CSAqIENoZWNrIHRoYXQgdGhlIHJlcXVpcmVkIG1ldGhvZHMgYXJlIHRoZXJlLgogCSAqLwotCWlm
IChjaGVja19lbmdpbmVfb3BzKG9wcykpCisJaWYgKGNoZWNrX2VuZ2luZV9vcHMoJnRkLT5vLCBv
cHMpKQogCQlyZXR1cm4gTlVMTDsKIAogCXJldCA9IG1hbGxvYyhzaXplb2YoKnJldCkpOwpkaWZm
IC0tZ2l0IGEvbWVtb3J5LmMgYi9tZW1vcnkuYwppbmRleCA1MDYwMjIzLi5jZjlmNjBhIDEwMDY0
NAotLS0gYS9tZW1vcnkuYworKysgYi9tZW1vcnkuYwpAQCAtMjM2LDYgKzIzNiw4IEBAIGludCBh
bGxvY2F0ZV9pb19tZW0oc3RydWN0IHRocmVhZF9kYXRhICp0ZCkKIAllbHNlIGlmICh0ZC0+by5t
ZW1fdHlwZSA9PSBNRU1fTU1BUCB8fCB0ZC0+by5tZW1fdHlwZSA9PSBNRU1fTU1BUEhVR0UgfHwK
IAkJIHRkLT5vLm1lbV90eXBlID09IE1FTV9NTUFQU0hBUkVEKQogCQlyZXQgPSBhbGxvY19tZW1f
bW1hcCh0ZCwgdG90YWxfbWVtKTsKKwllbHNlIGlmICh0ZC0+by5tZW1fdHlwZSA9PSBNRU1fSU9F
TkdJTkUpCisJCXJldCA9IHRkLT5pb19vcHMtPmlvbWVtX2FsbG9jKHRkLCB0b3RhbF9tZW0pOwog
CWVsc2UgewogCQlsb2dfZXJyKCJmaW86IGJhZCBtZW0gdHlwZTogJWRcbiIsIHRkLT5vLm1lbV90
eXBlKTsKIAkJcmV0ID0gMTsKQEAgLTI2Miw2ICsyNjQsOCBAQCB2b2lkIGZyZWVfaW9fbWVtKHN0
cnVjdCB0aHJlYWRfZGF0YSAqdGQpCiAJZWxzZSBpZiAodGQtPm8ubWVtX3R5cGUgPT0gTUVNX01N
QVAgfHwgdGQtPm8ubWVtX3R5cGUgPT0gTUVNX01NQVBIVUdFIHx8CiAJCSB0ZC0+by5tZW1fdHlw
ZSA9PSBNRU1fTU1BUFNIQVJFRCkKIAkJZnJlZV9tZW1fbW1hcCh0ZCwgdG90YWxfbWVtKTsKKwll
bHNlIGlmICh0ZC0+by5tZW1fdHlwZSA9PSBNRU1fSU9FTkdJTkUpCisJCXRkLT5pb19vcHMtPmlv
bWVtX2ZyZWUodGQpOwogCWVsc2UKIAkJbG9nX2VycigiQmFkIG1lbW9yeSB0eXBlICV1XG4iLCB0
ZC0+by5tZW1fdHlwZSk7CiAKZGlmZiAtLWdpdCBhL29wdGlvbnMuYyBiL29wdGlvbnMuYwppbmRl
eCAzOTAyMDg3Li4yOGE4ZmNhIDEwMDY0NAotLS0gYS9vcHRpb25zLmMKKysrIGIvb3B0aW9ucy5j
CkBAIC0yMTAwLDYgKzIxMDAsMTAgQEAgc3RydWN0IGZpb19vcHRpb24gZmlvX29wdGlvbnNbRklP
X01BWF9PUFRTXSA9IHsKIAkJCSAgICAuaGVscCA9ICJMaWtlIG1tYXAsIGJ1dCB1c2UgaHVnZSBw
YWdlcyIsCiAJCQkgIH0sCiAjZW5kaWYKKwkJCSAgeyAuaXZhbCA9ICJpb2VuZ2luZSIsCisJCQkg
ICAgLm92YWwgPSBNRU1fSU9FTkdJTkUsCisJCQkgICAgLmhlbHAgPSAiSS9PIGVuZ2luZSBwcm92
aWRlcyBhbGxvYy9mcmVlIG1ldGhvZHMiLAorCQkJICB9LAogCQkgIH0sCiAJfSwKIAl7CmRpZmYg
LS1naXQgYS90aHJlYWRfb3B0aW9ucy5oIGIvdGhyZWFkX29wdGlvbnMuaAppbmRleCAzODQ1MzRh
Li45OGZhZmEzIDEwMDY0NAotLS0gYS90aHJlYWRfb3B0aW9ucy5oCisrKyBiL3RocmVhZF9vcHRp
b25zLmgKQEAgLTIwLDYgKzIwLDcgQEAgZW51bSBmaW9fbWVtdHlwZSB7CiAJTUVNX01NQVAsCS8q
IHVzZSBhbm9ueW5vbW91cyBtbWFwICovCiAJTUVNX01NQVBIVUdFLAkvKiBtZW1vcnkgbWFwcGVk
IGh1Z2UgZmlsZSAqLwogCU1FTV9NTUFQU0hBUkVELCAvKiB1c2UgbW1hcCB3aXRoIHNoYXJlZCBm
bGFnICovCisJTUVNX0lPRU5HSU5FLAkvKiBtYW5hZ2VkIGJ5IEkvTyBlbmdpbmUgKi8KIH07CiAK
ICNkZWZpbmUgRVJST1JfU1RSX01BWAkxMjgK
--001a11c33f8025f50d052c869e7b--

