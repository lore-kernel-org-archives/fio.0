Return-Path: <bfulton@google.com>
MIME-Version: 1.0
Date: Thu, 23 Oct 2014 11:56:54 -0700
Message-ID: <CANff2=OEAOv6tOriBbhKkwndrpqMkhB8vj3RS9qtp=_uO8eiLQ@mail.gmail.com>
Subject: [RFC PATCH] Loop Iteration Offset Bug
From: Brian Fulton <bfulton@google.com>
Content-Type: text/plain; charset=UTF-8
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, Akash Verma <akashv@google.com>
List-ID: <fio@vger.kernel.org>

I have a proposal for a fix for the loop offset bug described here:
http://www.spinics.net/lists/fio/msg03386.html

- Brian


From 7272b3862cc3b3c22ddfb2d5b78348fe69c3fa2b Mon Sep 17 00:00:00 2001
From: Brian Fulton <bfulton@google.com>
Date: Thu, 23 Oct 2014 11:40:59 -0700
Subject: [PATCH 1/1] Reset file descriptor offset value to the initial value
 when file is closed and io state is cleared. This fixes the bug where
 previous offset values persist between loop iterations.

---
 libfio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libfio.c b/libfio.c
index 9ed802a..b823bd4 100644
--- a/libfio.c
+++ b/libfio.c
@@ -108,8 +108,10 @@ void clear_io_state(struct thread_data *td)
  reset_io_counters(td);

  close_files(td);
- for_each_file(td, f, i)
+ for_each_file(td, f, i) {
  fio_file_clear_done(f);
+ f->file_offset = get_start_offset(td, f);
+ }

  /*
   * Set the same seed to get repeatable runs

