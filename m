Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/5] use ARRAY_SIZE() for ignore_error_nr[etype]
Date: Wed,  7 Jun 2017 23:18:48 +0300
Message-Id: <20170607201849.9448-5-tkusumi@tuxera.com>
In-Reply-To: <20170607201849.9448-1-tkusumi@tuxera.com>
References: <20170607201849.9448-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 td_error.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/td_error.c b/td_error.c
index 903f9ea..9d58a31 100644
--- a/td_error.c
+++ b/td_error.c
@@ -20,8 +20,7 @@ int td_non_fatal_error(struct thread_data *td, enum error_type_bit etype,
 
 	if (!td->o.ignore_error[etype]) {
 		td->o.ignore_error[etype] = __NON_FATAL_ERR;
-		td->o.ignore_error_nr[etype] = sizeof(__NON_FATAL_ERR)
-			/ sizeof(int);
+		td->o.ignore_error_nr[etype] = ARRAY_SIZE(__NON_FATAL_ERR);
 	}
 
 	if (!(td->o.continue_on_error & (1 << etype)))
-- 
2.9.4


