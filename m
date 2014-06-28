Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Fri, 27 Jun 2014 17:54:26 -0700
Message-ID: <CANvN+ekEc4AW+0WcC2YwmJdXA4WO_APSqPQkhq5oexOdrD+UXw@mail.gmail.com>
Subject: A typo in io_u.c::get_next_file()?
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

diff --git a/io_u.c b/io_u.c
index e132fd9..f487b0a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1100,7 +1100,7 @@ out:

 static struct fio_file *get_next_file(struct thread_data *td)
 {
-       if (!(td->flags & TD_F_PROFILE_OPS)) {
+       if ((td->flags & TD_F_PROFILE_OPS)) {
                struct prof_io_ops *ops = &td->prof_io_ops;

                if (ops->get_next_file)


Regards,
Andrey

