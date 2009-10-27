Return-Path: <radha@google.com>
MIME-Version: 1.0
Date: Mon, 26 Oct 2009 17:10:14 -0700
Message-ID: <66dfd3fe0910261710n62740f75y6946ebd00b2f9ab6@mail.gmail.com>
Subject: Patch to write patterns > 4 bytes
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <jens.axboe@oracle.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi,
This is the patch I have to write/read/verify hex patterns of size > 4 bytes.
I have tested these on hard drives and did not see any performance
change. Iam assuming the performance drop if any might show up in the
read phase for probably solid state drives and maybe it can be worked
around using the asynchronous verify flag.
Thanks
-radha


diff --git a/HOWTO b/HOWTO
index aa10dbc..cdd6473 100644
--- a/HOWTO
+++ b/HOWTO
@@ -846,13 +846,14 @@ verify_interval=int       Write the verification
header at a finer granularity
                        size of header_interval. blocksize should divide this
                        evenly.

-verify_pattern=int     If set, fio will fill the io buffers with this
+verify_pattern=str     If set, fio will fill the io buffers with this
                pattern. Fio defaults to filling with totally random
                bytes, but sometimes it's interesting to fill with a known
                pattern for io verification purposes. Depending on the
                width of the pattern, fio will fill 1/2/3/4 bytes of the
-               buffer at the time. The verify_pattern cannot be larger than
-               a 32-bit quantity.
+               buffer at the time(it can be either a decimal or a hex number).
+               The verify_pattern if larger than a 32-bit quantity has to
+               be a hex number that starts with either "0x" or "0X".

 verify_fatal=bool      Normally fio will keep checking the entire contents
                before quitting on a block verification failure. If this
diff --git a/fio.h b/fio.h
index 049692d..e4ed76f 100644
--- a/fio.h
+++ b/fio.h
@@ -63,6 +63,8 @@ enum fio_memtype {
 #define FIO_IO_U_LAT_U_NR 10
 #define FIO_IO_U_LAT_M_NR 12

+#define MAX_PATTERN_SIZE 512
+
 struct thread_stat {
        char *name;
        char *verror;
@@ -175,7 +177,7 @@ struct thread_options {
        unsigned int verifysort;
        unsigned int verify_interval;
        unsigned int verify_offset;
-       unsigned int verify_pattern;
+       char verify_pattern[MAX_PATTERN_SIZE];
        unsigned int verify_pattern_bytes;
        unsigned int verify_fatal;
        unsigned int verify_async;
diff --git a/options.c b/options.c
index b5abd74..5b88255 100644
--- a/options.c
+++ b/options.c
@@ -33,6 +33,26 @@ static char *get_opt_postfix(const char *str)
        return strdup(p);
 }

+static int converthexchartoint(char a)
+{
+       int base;
+
+       switch(a) {
+       case '0'...'9':
+               base = '0';
+               break;
+       case 'A'...'F':
+               base = 'A' - 10;
+               break;
+       case 'a'...'f':
+               base = 'a' - 10;
+               break;
+       default:
+               base = 0;
+       }
+       return (a - base);
+}
+
 static int bs_cmp(const void *p1, const void *p2)
 {
        const struct bssplit *bsp1 = p1;
@@ -566,22 +586,45 @@ static int str_verify_offset_cb(void *data,
unsigned int *off)
        return 0;
 }

-static int str_verify_pattern_cb(void *data, unsigned int *off)
+static int str_verify_pattern_cb(void *data, const char *input)
 {
        struct thread_data *td = data;
-       unsigned int msb;
-
-       msb = __fls(*off);
-       if (msb <= 8)
-               td->o.verify_pattern_bytes = 1;
-       else if (msb <= 16)
-               td->o.verify_pattern_bytes = 2;
-       else if (msb <= 24)
-               td->o.verify_pattern_bytes = 3;
-       else
-               td->o.verify_pattern_bytes = 4;
-
-       td->o.verify_pattern = *off;
+       long off;
+       int i = 0, j = 0, len, k, base = 10;
+       char* loc1, * loc2;
+
+       loc1 = strstr(input, "0x");
+       loc2 = strstr(input, "0X");
+       if (loc1 || loc2)
+               base = 16;
+       off = strtol(input, NULL, base);
+       if (off != LONG_MAX || errno != ERANGE) {
+               while (off) {
+                       td->o.verify_pattern[i] = off & 0xff;
+                       off >>= 8;
+                       i++;
+               }
+       } else {
+               len = strlen(input);
+               k = len - 1;
+               if (base == 16) {
+                       if (loc1)
+                               j = loc1 - input + 2;
+                       else
+                               j = loc2 - input + 2;
+               } else
+                       return 1;
+               if (len - j < MAX_PATTERN_SIZE * 2) {
+                       while (k >= j) {
+                               off = converthexchartoint(input[k--]);
+                               if (k >= j)
+                                       off += (converthexchartoint(input[k--])
+                                               * 16);
+                               td->o.verify_pattern[i++] = (char) off;
+                       }
+               }
+       }
+       td->o.verify_pattern_bytes = i;
        return 0;
 }

@@ -1263,7 +1306,7 @@ static struct fio_option options[] = {
        },
        {
                .name   = "verify_pattern",
-               .type   = FIO_OPT_INT,
+               .type   = FIO_OPT_STR,
                .cb     = str_verify_pattern_cb,
                .help   = "Fill pattern for IO buffers",
                .parent = "verify",
diff --git a/verify.c b/verify.c
index 193e171..faa5684 100644
--- a/verify.c
+++ b/verify.c
@@ -53,38 +53,21 @@ static void fill_pattern(struct thread_data *td,
void *p, unsigned int len)
                break;
        case 1:
                dprint(FD_VERIFY, "fill verify pattern b=0 len=%u\n", len);
-               memset(p, td->o.verify_pattern, len);
+               memset(p, td->o.verify_pattern[0], len);
                break;
-       case 2:
-       case 3:
-       case 4: {
-               unsigned int pattern = td->o.verify_pattern;
-               unsigned int i = 0;
-               unsigned char c1, c2, c3, c4;
+       default: {
+               unsigned int i = 0, size = 0;
                unsigned char *b = p;

                dprint(FD_VERIFY, "fill verify pattern b=%d len=%u\n",
                                        td->o.verify_pattern_bytes, len);

-               c1 = pattern & 0xff;
-               pattern >>= 8;
-               c2 = pattern & 0xff;
-               pattern >>= 8;
-               c3 = pattern & 0xff;
-               pattern >>= 8;
-               c4 = pattern & 0xff;
-
                while (i < len) {
-                       b[i++] = c1;
-                       if (i == len)
-                               break;
-                       b[i++] = c2;
-                       if (td->o.verify_pattern_bytes == 2 || i == len)
-                               continue;
-                       b[i++] = c3;
-                       if (td->o.verify_pattern_bytes == 3 || i == len)
-                               continue;
-                       b[i++] = c4;
+                       size = td->o.verify_pattern_bytes;
+                       if (size > (len - i))
+                               size = len - i;
+                       memcpy(b+i, td->o.verify_pattern, size);
+                       i += size;
                }
                break;
                }
@@ -420,24 +403,18 @@ static unsigned int hweight8(unsigned int w)
        return (res + (res >> 4)) & 0x0F;
 }

-int verify_io_u_pattern(unsigned long pattern, unsigned long pattern_size,
+int verify_io_u_pattern(char *pattern, unsigned long pattern_size,
                        char *buf, unsigned int len, unsigned int mod)
 {
        unsigned int i;
-       char split_pattern[4];
-
-       for (i = 0; i < 4; i++) {
-               split_pattern[i] = pattern & 0xff;
-               pattern >>= 8;
-       }

        for (i = 0; i < len; i++) {
-               if (buf[i] != split_pattern[mod]) {
+               if (buf[i] != pattern[mod]) {
                        unsigned int bits;

-                       bits = hweight8(buf[i] ^ split_pattern[mod]);
+                       bits = hweight8(buf[i] ^ pattern[mod]);
                        log_err("fio: got pattern %x, wanted %x. Bad bits %d\n",
-                               buf[i], split_pattern[mod], bits);
+                               buf[i], pattern[mod], bits);
                        log_err("fio: bad pattern block offset %u\n", i);
                        return EILSEQ;
                }
@@ -504,10 +481,10 @@ int verify_io_u(struct thread_data *td, struct io_u *io_u)
                        dprint(FD_VERIFY, "pattern verify io_u %p, len %u\n",
                                                                io_u, hdr->len);
                        ret = verify_io_u_pattern(td->o.verify_pattern,
-                                                 td->o.verify_pattern_bytes,
-                                                 p + hdr_size,
-                                                 hdr_inc - hdr_size,
-                                                 hdr_size % 4);
+                                 td->o.verify_pattern_bytes,
+                                 p + hdr_size,
+                                 hdr_inc - hdr_size,
+                                 hdr_size % td->o.verify_pattern_bytes);
                        /*
                         * Also verify the meta data, if applicable
                         */

