Return-Path: <vincent.fu@samsung.com>
From: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 1/2] backend: clarify io scheduler setting error message
Date: Wed, 4 Aug 2021 18:29:04 +0000
Message-ID: <20210804182841.8780-2-vincent.fu@samsung.com>
In-Reply-To: <20210804182841.8780-1-vincent.fu@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
References: <20210804182841.8780-1-vincent.fu@samsung.com>
	<CGME20210804182905uscas1p2c6194b189e05c087e5cb4813c3c7abff@uscas1p2.samsung.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Vincent Fu <vincent.fu@samsung.com>
List-ID: <fio@vger.kernel.org>

If you know *how* fio tries to confirm that the IO scheduler was
successfully set, then the error message "io scheduler not found" makes
sense. However, if you don't know what fio does to confirm the io
scheduler setting, then the error message is confusing. This patch
modifies the error message to indicate that the selected IO scheduler
could not be set.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 backend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/backend.c b/backend.c
index 6290e0d6..808e4362 100644
--- a/backend.c
+++ b/backend.c
@@ -1407,7 +1407,7 @@ static int set_ioscheduler(struct thread_data *td, st=
ruct fio_file *file)
=20
 	sprintf(tmp2, "[%s]", td->o.ioscheduler);
 	if (!strstr(tmp, tmp2)) {
-		log_err("fio: io scheduler %s not found\n", td->o.ioscheduler);
+		log_err("fio: unable to set io scheduler to %s\n", td->o.ioscheduler);
 		td_verror(td, EINVAL, "iosched_switch");
 		fclose(f);
 		return 1;
--=20
2.25.1

