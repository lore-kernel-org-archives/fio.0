Return-Path: <ms@teamix.de>
MIME-Version: 1.0
From: Martin Steigerwald <ms@teamix.de>
Date: Mon, 7 May 2012 08:18:24 -0600
Subject: [PATCH 1/3] Fix spelling error in manpage.
Message-ID: 
 <5df008af9a2c71c1b680c554a7c8c0ab6041b9f7.1336399881.git.ms@teamix.de>
References: <1336400306-12173-1-git-send-email-ms@teamix.de>
In-Reply-To: <1336400306-12173-1-git-send-email-ms@teamix.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <JAxboe@fusionio.com>, Martin Steigerwald <ms@teamix.de>
List-ID: <fio@vger.kernel.org>

---
 fio.1 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fio.1 b/fio.1
index 7997526..4e626b0 100644
--- a/fio.1
+++ b/fio.1
@@ -70,7 +70,7 @@ Set the internal smalloc pool size to \fIkb\fP kilobytes.
 All fio parser warnings are fatal, causing fio to exit with an error.
 .TP
 .BI \-\-max\-jobs \fR=3D\fPnr
-Set the maximum allowed number of jobs (threads/processes) to suport.
+Set the maximum allowed number of jobs (threads/processes) to support.
 .TP
 .BI \-\-server \fR=3D\fPargs
 Start a backend server, with \fIargs\fP specifying what to listen to. See =
client/server section.
--=20
1.7.10


