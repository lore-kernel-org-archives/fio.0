Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 7/8] Fix num2str() output when maxlen <= strlen(tmp)
Date: Tue,  4 Apr 2017 23:22:17 +0300
Message-Id: <20170404202218.52260-7-tkusumi@tuxera.com>
In-Reply-To: <20170404202218.52260-1-tkusumi@tuxera.com>
References: <20170404202218.52260-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Since a local variable decimals is unsigned int, this conditional
 if (decimals <= 1)
needs cast as shown below.
 if ((int)decimals <= 1)

Otherwise it results in showing some garbage in case of maxlen == 0,

 # cat ./test0.c
 #include <stdio.h>
 #include "lib/num2str.h"
 int main(void) {
         printf("%s\n", num2str(123, 3, 1, 1, N2S_BYTE));
         printf("%s\n", num2str(123, 2, 1, 1, N2S_BYTE));
         printf("%s\n", num2str(123, 1, 1, 1, N2S_BYTE));
         printf("%s\n", num2str(123, 0, 1, 1, N2S_BYTE));
         return 0;
 }
 # gcc -Wall -g -DCONFIG_STATIC_ASSERT ./test0.c ./lib/num2str.c
 # ./a.out
 123B
 0KiB
 0KiB
 0.0?$-JB
 # ./a.out
 123B
 0KiB
 0KiB
 0.0#;bB
 # ./a.out
 123B
 0KiB
 0KiB
 0.0|B

whereas with this commit it prints "0B".

 # gcc -Wall -g -DCONFIG_STATIC_ASSERT ./test0.c ./lib/num2str.c
 # ./a.out
 123B
 0KiB
 0KiB
 0B

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 lib/num2str.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/num2str.c b/lib/num2str.c
index 2f714cc..448d3ff 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -86,7 +86,7 @@ done:
 
 	sprintf(tmp, "%llu", (unsigned long long) num);
 	decimals = maxlen - strlen(tmp);
-	if (decimals <= 1) {
+	if ((int)decimals <= 1) {
 		if (carry)
 			num++;
 		goto done;
-- 
2.9.3


