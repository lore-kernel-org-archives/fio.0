Return-Path: <radha@google.com>
MIME-Version: 1.0
Date: Thu, 23 Jul 2009 12:33:36 -0700
Message-ID: <66dfd3fe0907231233u53c30fe7l20c4b1103459292c@mail.gmail.com>
Subject: Verify pattern & header meta data
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: fio@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-ID: <fio@vger.kernel.org>

Hi,
Is there any reason why during the verify phase, when the pattern
verification is on, there is no meta verification done. I see why
doing pattern verify followed by a crc/md5/sha verification can be
redundant, but I think it is useful to have meta verify check even if
there is pattern verification just to confirm that the data was read
from the correct location as expected.
If this is reasonable I have a change to check meta data after pattern
verification where applicable:


>git diff
diff --git a/verify.c b/verify.c
index 84fc015..3c8997a 100644
--- a/verify.c
+++ b/verify.c
@@ -482,6 +482,12 @@ int verify_io_u(struct thread_data *td, struct io_u *io_u)
                                log_err("fio: verify failed at %llu/%u\n",
                                        io_u->offset + hdr_num * hdr->len,
                                        hdr->len);
+                       /*
+                        * Also verify the meta data if applicable.
+                        */
+                       if (hdr->verify_type == VERIFY_META) {
+                               ret = ret | verify_io_u_meta(hdr, td,
io_u, hdr_num);
+                       }
                        continue;
                }

Thanks
-radha

