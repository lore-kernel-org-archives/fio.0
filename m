Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Wed, 24 Feb 2016 00:16:55 +0300
Message-ID: <CANvN+e=-VtHTeaRftjvPJUjhgVY9nD85gn=6D4+TyQeLrEE_cw@mail.gmail.com>
Subject: [PATCH]: Let I/O engine provide methods to allocate/free I/O memory.
Content-Type: multipart/mixed; boundary=001a11402bec3ddf51052c7679ef
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--001a11402bec3ddf51052c7679ef
Content-Type: multipart/alternative; boundary=001a11402bec3ddf4c052c7679ed

--001a11402bec3ddf4c052c7679ed
Content-Type: text/plain; charset=UTF-8

I/O engine may have special needs as to how the I/O memory should be
allocated. The below patch adds respective methods to the I/O engine
interface.

Regards,
Andrey

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
diff --git a/memory.c b/memory.c
index 5060223..4d5d474 100644
--- a/memory.c
+++ b/memory.c
@@ -229,7 +229,9 @@ int allocate_io_mem(struct thread_data *td)

     dprint(FD_MEM, "Alloc %llu for buffers\n", (unsigned long long)
total_mem);

-    if (td->o.mem_type == MEM_MALLOC)
+    if (td->io_ops->iomem_alloc)
+        ret = td->io_ops->iomem_alloc(td, total_mem);
+    else if (td->o.mem_type == MEM_MALLOC)
         ret = alloc_mem_malloc(td, total_mem);
     else if (td->o.mem_type == MEM_SHM || td->o.mem_type == MEM_SHMHUGE)
         ret = alloc_mem_shm(td, total_mem);
@@ -255,7 +257,9 @@ void free_io_mem(struct thread_data *td)
     if (td->o.odirect || td->o.oatomic)
         total_mem += page_mask;

-    if (td->o.mem_type == MEM_MALLOC)
+    if (td->io_ops->iomem_free)
+        td->io_ops->iomem_free(td);
+    else if (td->o.mem_type == MEM_MALLOC)
         free_mem_malloc(td);
     else if (td->o.mem_type == MEM_SHM || td->o.mem_type == MEM_SHMHUGE)
         free_mem_shm(td);

--001a11402bec3ddf4c052c7679ed
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I/O engine may have special needs as to how the I/O memory=
 should be allocated. The below patch adds respective methods to the I/O en=
gine interface.<br><br>Regards,<br>Andrey<br><br>diff --git a/ioengine.h b/=
ioengine.h<br>index 6734c7b..161acf5 100644<br>--- a/ioengine.h<br>+++ b/io=
engine.h<br>@@ -16,7 +16,7 @@<br>=C2=A0#include &lt;guasi.h&gt;<br>=C2=A0#e=
ndif<br>=C2=A0<br>-#define FIO_IOOPS_VERSION=C2=A0=C2=A0=C2=A0 22<br>+#defi=
ne FIO_IOOPS_VERSION=C2=A0=C2=A0=C2=A0 23<br>=C2=A0<br>=C2=A0enum {<br>=C2=
=A0=C2=A0=C2=A0=C2=A0 IO_U_F_FREE=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =3D =
1 &lt;&lt; 0,<br>@@ -157,6 +157,8 @@ struct ioengine_ops {<br>=C2=A0=C2=A0=
=C2=A0=C2=A0 int (*unlink_file)(struct thread_data *, struct fio_file *);<b=
r>=C2=A0=C2=A0=C2=A0=C2=A0 int (*get_file_size)(struct thread_data *, struc=
t fio_file *);<br>=C2=A0=C2=A0=C2=A0=C2=A0 void (*terminate)(struct thread_=
data *);<br>+=C2=A0=C2=A0=C2=A0 int (*iomem_alloc)(struct thread_data *, si=
ze_t);<br>+=C2=A0=C2=A0=C2=A0 void (*iomem_free)(struct thread_data *);<br>=
=C2=A0=C2=A0=C2=A0=C2=A0 int (*io_u_init)(struct thread_data *, struct io_u=
 *);<br>=C2=A0=C2=A0=C2=A0=C2=A0 void (*io_u_free)(struct thread_data *, st=
ruct io_u *);<br>=C2=A0=C2=A0=C2=A0=C2=A0 int option_struct_size;<br>diff -=
-git a/memory.c b/memory.c<br>index 5060223..4d5d474 100644<br>--- a/memory=
.c<br>+++ b/memory.c<br>@@ -229,7 +229,9 @@ int allocate_io_mem(struct thre=
ad_data *td)<br>=C2=A0<br>=C2=A0=C2=A0=C2=A0=C2=A0 dprint(FD_MEM, &quot;All=
oc %llu for buffers\n&quot;, (unsigned long long) total_mem);<br>=C2=A0<br>=
-=C2=A0=C2=A0=C2=A0 if (td-&gt;o.mem_type =3D=3D MEM_MALLOC)<br>+=C2=A0=C2=
=A0=C2=A0 if (td-&gt;io_ops-&gt;iomem_alloc)<br>+=C2=A0=C2=A0=C2=A0 =C2=A0=
=C2=A0=C2=A0 ret =3D td-&gt;io_ops-&gt;iomem_alloc(td, total_mem);<br>+=C2=
=A0=C2=A0=C2=A0 else if (td-&gt;o.mem_type =3D=3D MEM_MALLOC)<br>=C2=A0=C2=
=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 ret =3D alloc_mem_malloc(td, total_mem);=
<br>=C2=A0=C2=A0=C2=A0=C2=A0 else if (td-&gt;o.mem_type =3D=3D MEM_SHM || t=
d-&gt;o.mem_type =3D=3D MEM_SHMHUGE)<br>=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=
=A0=C2=A0 ret =3D alloc_mem_shm(td, total_mem);<br>@@ -255,7 +257,9 @@ void=
 free_io_mem(struct thread_data *td)<br>=C2=A0=C2=A0=C2=A0=C2=A0 if (td-&gt=
;o.odirect || td-&gt;o.oatomic)<br>=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=
=A0 total_mem +=3D page_mask;<br>=C2=A0<br>-=C2=A0=C2=A0=C2=A0 if (td-&gt;o=
.mem_type =3D=3D MEM_MALLOC)<br>+=C2=A0=C2=A0=C2=A0 if (td-&gt;io_ops-&gt;i=
omem_free)<br>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 td-&gt;io_ops-&gt;iome=
m_free(td);<br>+=C2=A0=C2=A0=C2=A0 else if (td-&gt;o.mem_type =3D=3D MEM_MA=
LLOC)<br>=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 free_mem_malloc(td);<b=
r>=C2=A0=C2=A0=C2=A0=C2=A0 else if (td-&gt;o.mem_type =3D=3D MEM_SHM || td-=
&gt;o.mem_type =3D=3D MEM_SHMHUGE)<br>=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0 free_mem_shm(td);<br></div>

--001a11402bec3ddf4c052c7679ed--

--001a11402bec3ddf51052c7679ef
Content-Type: text/x-patch; charset=US-ASCII; name="Let-io-engine-allocate-io-memory.patch"
Content-Disposition: attachment; 
	filename="Let-io-engine-allocate-io-memory.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ikzwwrkz0

ZGlmZiAtLWdpdCBhL2lvZW5naW5lLmggYi9pb2VuZ2luZS5oCmluZGV4IDY3MzRjN2IuLjE2MWFj
ZjUgMTAwNjQ0Ci0tLSBhL2lvZW5naW5lLmgKKysrIGIvaW9lbmdpbmUuaApAQCAtMTYsNyArMTYs
NyBAQAogI2luY2x1ZGUgPGd1YXNpLmg+CiAjZW5kaWYKIAotI2RlZmluZSBGSU9fSU9PUFNfVkVS
U0lPTgkyMgorI2RlZmluZSBGSU9fSU9PUFNfVkVSU0lPTgkyMwogCiBlbnVtIHsKIAlJT19VX0Zf
RlJFRQkJPSAxIDw8IDAsCkBAIC0xNTcsNiArMTU3LDggQEAgc3RydWN0IGlvZW5naW5lX29wcyB7
CiAJaW50ICgqdW5saW5rX2ZpbGUpKHN0cnVjdCB0aHJlYWRfZGF0YSAqLCBzdHJ1Y3QgZmlvX2Zp
bGUgKik7CiAJaW50ICgqZ2V0X2ZpbGVfc2l6ZSkoc3RydWN0IHRocmVhZF9kYXRhICosIHN0cnVj
dCBmaW9fZmlsZSAqKTsKIAl2b2lkICgqdGVybWluYXRlKShzdHJ1Y3QgdGhyZWFkX2RhdGEgKik7
CisJaW50ICgqaW9tZW1fYWxsb2MpKHN0cnVjdCB0aHJlYWRfZGF0YSAqLCBzaXplX3QpOworCXZv
aWQgKCppb21lbV9mcmVlKShzdHJ1Y3QgdGhyZWFkX2RhdGEgKik7CiAJaW50ICgqaW9fdV9pbml0
KShzdHJ1Y3QgdGhyZWFkX2RhdGEgKiwgc3RydWN0IGlvX3UgKik7CiAJdm9pZCAoKmlvX3VfZnJl
ZSkoc3RydWN0IHRocmVhZF9kYXRhICosIHN0cnVjdCBpb191ICopOwogCWludCBvcHRpb25fc3Ry
dWN0X3NpemU7CmRpZmYgLS1naXQgYS9tZW1vcnkuYyBiL21lbW9yeS5jCmluZGV4IDUwNjAyMjMu
LjRkNWQ0NzQgMTAwNjQ0Ci0tLSBhL21lbW9yeS5jCisrKyBiL21lbW9yeS5jCkBAIC0yMjksNyAr
MjI5LDkgQEAgaW50IGFsbG9jYXRlX2lvX21lbShzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRkKQogCiAJ
ZHByaW50KEZEX01FTSwgIkFsbG9jICVsbHUgZm9yIGJ1ZmZlcnNcbiIsICh1bnNpZ25lZCBsb25n
IGxvbmcpIHRvdGFsX21lbSk7CiAKLQlpZiAodGQtPm8ubWVtX3R5cGUgPT0gTUVNX01BTExPQykK
KwlpZiAodGQtPmlvX29wcy0+aW9tZW1fYWxsb2MpCisJCXJldCA9IHRkLT5pb19vcHMtPmlvbWVt
X2FsbG9jKHRkLCB0b3RhbF9tZW0pOworCWVsc2UgaWYgKHRkLT5vLm1lbV90eXBlID09IE1FTV9N
QUxMT0MpCiAJCXJldCA9IGFsbG9jX21lbV9tYWxsb2ModGQsIHRvdGFsX21lbSk7CiAJZWxzZSBp
ZiAodGQtPm8ubWVtX3R5cGUgPT0gTUVNX1NITSB8fCB0ZC0+by5tZW1fdHlwZSA9PSBNRU1fU0hN
SFVHRSkKIAkJcmV0ID0gYWxsb2NfbWVtX3NobSh0ZCwgdG90YWxfbWVtKTsKQEAgLTI1NSw3ICsy
NTcsOSBAQCB2b2lkIGZyZWVfaW9fbWVtKHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQpCiAJaWYgKHRk
LT5vLm9kaXJlY3QgfHwgdGQtPm8ub2F0b21pYykKIAkJdG90YWxfbWVtICs9IHBhZ2VfbWFzazsK
IAotCWlmICh0ZC0+by5tZW1fdHlwZSA9PSBNRU1fTUFMTE9DKQorCWlmICh0ZC0+aW9fb3BzLT5p
b21lbV9mcmVlKQorCQl0ZC0+aW9fb3BzLT5pb21lbV9mcmVlKHRkKTsKKwllbHNlIGlmICh0ZC0+
by5tZW1fdHlwZSA9PSBNRU1fTUFMTE9DKQogCQlmcmVlX21lbV9tYWxsb2ModGQpOwogCWVsc2Ug
aWYgKHRkLT5vLm1lbV90eXBlID09IE1FTV9TSE0gfHwgdGQtPm8ubWVtX3R5cGUgPT0gTUVNX1NI
TUhVR0UpCiAJCWZyZWVfbWVtX3NobSh0ZCk7Cg==
--001a11402bec3ddf51052c7679ef--

