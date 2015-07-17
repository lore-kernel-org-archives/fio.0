Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Fri, 17 Jul 2015 17:30:12 +0300
Message-ID: <CANvN+ekBVCAMge-A9dMTeOnXSJ7sZ9OdQ_ZMeqgcTsoa8J0bJg@mail.gmail.com>
Subject: PATCH: Don't lose pending completions on exit in time- or size-based
 job with asynchronous I/O engine
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Probably worth adding to do_verify() as well.

Regards,
Andrey

diff --git a/backend.c b/backend.c
index 9ac94ed..c782fde 100644
--- a/backend.c
+++ b/backend.c
@@ -803,7 +803,8 @@ static uint64_t do_io(struct thread_data *td)
                total_bytes += td->total_io_size;

        while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
-               (!flist_empty(&td->trim_list)) ||
!io_issue_bytes_exceeded(td) ||
+               (!flist_empty(&td->trim_list)) ||
+               !(io_issue_bytes_exceeded(td) && !td->cur_depth) ||
                td->o.time_based) {
                struct timeval comp_time;
                struct io_u *io_u;
@@ -819,7 +820,7 @@ static uint64_t do_io(struct thread_data *td)

                if (runtime_exceeded(td, &td->tv_cache)) {
                        __update_tv_cache(td);
-                       if (runtime_exceeded(td, &td->tv_cache)) {
+                       if (runtime_exceeded(td, &td->tv_cache) &&
!td->cur_depth) {
                                fio_mark_td_terminate(td);
                                break;
                        }
@@ -828,7 +829,7 @@ static uint64_t do_io(struct thread_data *td)
                if (flow_threshold_exceeded(td))
                        continue;

-               if (bytes_issued >= total_bytes)
+               if (bytes_issued >= total_bytes && !td->cur_depth)
                        break;

                io_u = get_io_u(td);

