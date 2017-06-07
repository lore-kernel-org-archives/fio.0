Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/5] don't leave ignore_error_nr[etype] with 4 on blank input or error
Date: Wed,  7 Jun 2017 23:18:46 +0300
Message-Id: <20170607201849.9448-3-tkusumi@tuxera.com>
In-Reply-To: <20170607201849.9448-1-tkusumi@tuxera.com>
References: <20170607201849.9448-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This isn't a bug since td_non_fatal_error() checks errnos to ignore
by td->o.ignore_error[etype] being NULL or not, but it's still strange
to leave td->o.ignore_error_nr[etype] with 4 (or multiple of 4 on
error) when there aren't any.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 options.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/options.c b/options.c
index 864e778..4214f24 100644
--- a/options.c
+++ b/options.c
@@ -306,8 +306,9 @@ static int ignore_error_type(struct thread_data *td, int etype, char *str)
 				error[i] = -error[i];
 		}
 		if (!error[i]) {
-			log_err("Unknown error %s, please use number value \n",
+			log_err("Unknown error %s, please use number value\n",
 				  fname);
+			td->o.ignore_error_nr[etype] = 0;
 			free(error);
 			return 1;
 		}
@@ -317,8 +318,10 @@ static int ignore_error_type(struct thread_data *td, int etype, char *str)
 		td->o.continue_on_error |= 1 << etype;
 		td->o.ignore_error_nr[etype] = i;
 		td->o.ignore_error[etype] = error;
-	} else
+	} else {
+		td->o.ignore_error_nr[etype] = 0;
 		free(error);
+	}
 
 	return 0;
 
-- 
2.9.4


