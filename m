Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/6] Bring in additional sg error cases from Linux kernel (and sg3) header
Date: Mon,  9 Jan 2017 23:41:58 +0900
Message-Id: <1483972923-13662-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/sg.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/engines/sg.c b/engines/sg.c
index 2ad3394..c9a1448 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -630,6 +630,24 @@ static char *fio_sgio_errdetails(struct io_u *io_u)
 			case 0x0d:
 				strlcat(msg, "SG_ERR_DID_REQUEUE", MAXERRDETAIL);
 				break;
+			case 0x0e:
+				strlcat(msg, "SG_ERR_DID_TRANSPORT_DISRUPTED", MAXERRDETAIL);
+				break;
+			case 0x0f:
+				strlcat(msg, "SG_ERR_DID_TRANSPORT_FAILFAST", MAXERRDETAIL);
+				break;
+			case 0x10:
+				strlcat(msg, "SG_ERR_DID_TARGET_FAILURE", MAXERRDETAIL);
+				break;
+			case 0x11:
+				strlcat(msg, "SG_ERR_DID_NEXUS_FAILURE", MAXERRDETAIL);
+				break;
+			case 0x12:
+				strlcat(msg, "SG_ERR_DID_ALLOC_FAILURE", MAXERRDETAIL);
+				break;
+			case 0x13:
+				strlcat(msg, "SG_ERR_DID_MEDIUM_ERROR", MAXERRDETAIL);
+				break;
 			default:
 				strlcat(msg, "Unknown", MAXERRDETAIL);
 				break;
-- 
2.5.5


