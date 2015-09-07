Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Mon, 7 Sep 2015 18:11:46 +0300
Message-ID: <CANvN+entGv7PSde2Q_Ehm7CCMeVO_WLQow-ea9vY6ViXB+=mQg@mail.gmail.com>
Subject: Ensure submission offload worker inherits parent's options
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Seems to be broken otherwise.

Regards,
Andrey

    Properly initialize sibling's eo, as otherwise it will miss parent's
    options.

diff --git a/workqueue.c b/workqueue.c
index 0a6cd20..f481027 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -161,6 +161,7 @@ static int init_submit_worker(struct submit_worker *sw)
        memcpy(&td->ts, &parent->ts, sizeof(td->ts));
        td->o.uid = td->o.gid = -1U;
        dup_files(td, parent);
+       td->eo = parent->eo;
        fio_options_mem_dupe(td);

        if (ioengine_load(td))

