Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/5] HOWTO: mention some details of ignore_error= option
Date: Wed,  7 Jun 2017 23:18:49 +0300
Message-Id: <20170607201849.9448-6-tkusumi@tuxera.com>
In-Reply-To: <20170607201849.9448-1-tkusumi@tuxera.com>
References: <20170607201849.9448-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

ignore_error= and continue_on_error= are related in their
implementation, and easier to understand how they differ by
mentioning to it.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index ea9466a..289c518 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2836,7 +2836,8 @@ Error handling
 .. option:: ignore_error=str
 
 	Sometimes you want to ignore some errors during test in that case you can
-	specify error list for each error type.
+	specify error list for each error type, instead of only being able to
+	ignore the default 'non-fatal error' using :option:`continue_on_error`.
 	``ignore_error=READ_ERR_LIST,WRITE_ERR_LIST,VERIFY_ERR_LIST`` errors for
 	given error type is separated with ':'. Error may be symbol ('ENOSPC',
 	'ENOMEM') or integer.  Example::
@@ -2844,7 +2845,8 @@ Error handling
 		ignore_error=EAGAIN,ENOSPC:122
 
 	This option will ignore EAGAIN from READ, and ENOSPC and 122(EDQUOT) from
-	WRITE.
+	WRITE. This option works by overriding :option:`continue_on_error` with
+	the list of errors for each error type if any.
 
 .. option:: error_dump=bool
 
-- 
2.9.4


