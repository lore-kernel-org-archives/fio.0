Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 8/8] Fix num2str() output when modulo != -1U
Date: Tue,  4 Apr 2017 23:22:18 +0300
Message-Id: <20170404202218.52260-8-tkusumi@tuxera.com>
In-Reply-To: <20170404202218.52260-1-tkusumi@tuxera.com>
References: <20170404202218.52260-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

I'm not sure what 05463816 actually fixed (as it only says "fix"),
but this isn't properly working at least for some input numbers unless
".%s" part of sprintf() is meant to be something other than decimal
part of the input number.

This commit might be breaking something that 05463816 had fixed,
which then needs to be rejected, but it at least prints decimal number
as expected. For example, when 12345 is 12.0556640625 KiB, and 23456
is 22.90625 KiB,

 # python -c "print(12345.0 / 1024)"
 12.0556640625
 # python -c "print(23456.0 / 1024)"
 22.90625

running this code as well as fio result in

 # cat ./test1.c
 #include <stdio.h>
 #include "lib/num2str.h"
 int main(void) {
         printf("%s-%s\n",
                 num2str(12345, 4, 1, 1, N2S_BYTE),
                 num2str(23456, 4, 1, 1, N2S_BYTE));
         return 0;
 }
 # gcc -Wall -g -DCONFIG_STATIC_ASSERT ./test1.c ./lib/num2str.c

below with the current implementation

 # ./a.out
 12.6KiB-22.1KiB
 # ./fio --name=xxxxx --ioengine=sync --rw=read --size=1m --unlink=1 --bsrange=12345:23456 | grep "rw=read"
 xxxxx: (g=0): rw=read, bs=(R) 12.6KiB-22.1KiB, (W) 12.6KiB-22.1KiB, (T) 12.6KiB-22.1KiB, ioengine=sync, iodepth=1

whereas below with this commit.

 # ./a.out
 12.1KiB-22.9KiB
 # ./fio --name=xxxxx --ioengine=sync --rw=read --size=1m --unlink=1 --bsrange=12345:23456 | grep "rw=read"
 xxxxx: (g=0): rw=read, bs=(R) 12.1KiB-22.9KiB, (W) 12.1KiB-22.9KiB, (T) 12.1KiB-22.9KiB, ioengine=sync, iodepth=1

-- some more verification with various parameters
 # cat ./testx.c
 #include <stdio.h>
 #include "lib/num2str.h"
 static void f(uint64_t n, int maxlen, int base, int pow2, int units) {
 	printf("%10jd %s\n", n, num2str(n, maxlen, base, pow2, units));
 }
 int main(void) {
 	/* 1 */
 	f(1, 1, 1, 1, N2S_BYTE);
 	f(1, 1, 1, 0, N2S_BYTE);
 	printf("====================\n");
 	/* 10 */
 	f(10, 2, 1, 1, N2S_BYTE);
 	f(10, 2, 1, 0, N2S_BYTE);
 	printf("====================\n");
 	/* 1000 */
 	f(1000, 5, 1, 1, N2S_BYTE);
 	f(1000, 5, 1, 0, N2S_BYTE);
 	f(1000, 4, 1, 1, N2S_BYTE);
 	f(1000, 4, 1, 0, N2S_BYTE);
 	f(1000, 3, 1, 1, N2S_BYTE);
 	f(1000, 3, 1, 0, N2S_BYTE);
 	f(1000, 2, 1, 1, N2S_BYTE);
 	f(1000, 2, 1, 0, N2S_BYTE);
 	f(1000, 1, 1, 1, N2S_BYTE);
 	f(1000, 1, 1, 0, N2S_BYTE);
 	printf("====================\n");
 	/* 1024 */
 	f(1024, 5, 1, 1, N2S_BYTE);
 	f(1024, 5, 1, 0, N2S_BYTE);
 	f(1024, 4, 1, 1, N2S_BYTE);
 	f(1024, 4, 1, 0, N2S_BYTE);
 	f(1024, 3, 1, 1, N2S_BYTE);
 	f(1024, 3, 1, 0, N2S_BYTE);
 	f(1024, 2, 1, 1, N2S_BYTE);
 	f(1024, 2, 1, 0, N2S_BYTE);
 	f(1024, 1, 1, 1, N2S_BYTE);
 	f(1024, 1, 1, 0, N2S_BYTE);
 	printf("====================\n");
 	/* 12345 */
 	f(12345, 6, 1, 1, N2S_BYTE);
 	f(12345, 6, 1, 0, N2S_BYTE);
 	f(12345, 5, 1, 1, N2S_BYTE);
 	f(12345, 5, 1, 0, N2S_BYTE);
 	f(12345, 4, 1, 1, N2S_BYTE);
 	f(12345, 4, 1, 0, N2S_BYTE);
 	f(12345, 3, 1, 1, N2S_BYTE);
 	f(12345, 3, 1, 0, N2S_BYTE);
 	f(12345, 2, 1, 1, N2S_BYTE);
 	f(12345, 2, 1, 0, N2S_BYTE);
 	f(12345, 1, 1, 1, N2S_BYTE);
 	f(12345, 1, 1, 0, N2S_BYTE);
 	printf("====================\n");
 	/* 1234567 */
 	f(1234567, 8, 1, 1, N2S_BYTE);
 	f(1234567, 8, 1, 0, N2S_BYTE);
 	f(1234567, 7, 1, 1, N2S_BYTE);
 	f(1234567, 7, 1, 0, N2S_BYTE);
 	f(1234567, 6, 1, 1, N2S_BYTE);
 	f(1234567, 6, 1, 0, N2S_BYTE);
 	f(1234567, 5, 1, 1, N2S_BYTE);
 	f(1234567, 5, 1, 0, N2S_BYTE);
 	f(1234567, 4, 1, 1, N2S_BYTE);
 	f(1234567, 4, 1, 0, N2S_BYTE);
 	f(1234567, 3, 1, 1, N2S_BYTE);
 	f(1234567, 3, 1, 0, N2S_BYTE);
 	f(1234567, 2, 1, 1, N2S_BYTE);
 	f(1234567, 2, 1, 0, N2S_BYTE);
 	f(1234567, 1, 1, 1, N2S_BYTE);
 	f(1234567, 1, 1, 0, N2S_BYTE);
 	printf("====================\n");
 	/* 1234567 with base 1024 */
 	f(1234567, 8, 1024, 1, N2S_BYTE);
 	f(1234567, 8, 1024, 0, N2S_BYTE);
 	f(1234567, 7, 1024, 1, N2S_BYTE);
 	f(1234567, 7, 1024, 0, N2S_BYTE);
 	f(1234567, 6, 1024, 1, N2S_BYTE);
 	f(1234567, 6, 1024, 0, N2S_BYTE);
 	f(1234567, 5, 1024, 1, N2S_BYTE);
 	f(1234567, 5, 1024, 0, N2S_BYTE);
 	f(1234567, 4, 1024, 1, N2S_BYTE);
 	f(1234567, 4, 1024, 0, N2S_BYTE);
 	f(1234567, 3, 1024, 1, N2S_BYTE);
 	f(1234567, 3, 1024, 0, N2S_BYTE);
 	f(1234567, 2, 1024, 1, N2S_BYTE);
 	f(1234567, 2, 1024, 0, N2S_BYTE);
 	f(1234567, 1, 1024, 1, N2S_BYTE);
 	f(1234567, 1, 1024, 0, N2S_BYTE);
 	printf("====================\n");
 	/* 1234567 with base 1024 with N2S_BIT */
 	f(1234567, 9, 1024, 1, N2S_BIT);
 	f(1234567, 9, 1024, 0, N2S_BIT);
 	f(1234567, 8, 1024, 1, N2S_BIT);
 	f(1234567, 8, 1024, 0, N2S_BIT);
 	f(1234567, 7, 1024, 1, N2S_BIT);
 	f(1234567, 7, 1024, 0, N2S_BIT);
 	f(1234567, 6, 1024, 1, N2S_BIT);
 	f(1234567, 6, 1024, 0, N2S_BIT);
 	f(1234567, 5, 1024, 1, N2S_BIT);
 	f(1234567, 5, 1024, 0, N2S_BIT);
 	f(1234567, 4, 1024, 1, N2S_BIT);
 	f(1234567, 4, 1024, 0, N2S_BIT);
 	f(1234567, 3, 1024, 1, N2S_BIT);
 	f(1234567, 3, 1024, 0, N2S_BIT);
 	f(1234567, 2, 1024, 1, N2S_BIT);
 	f(1234567, 2, 1024, 0, N2S_BIT);
 	f(1234567, 1, 1024, 1, N2S_BIT);
 	f(1234567, 1, 1024, 0, N2S_BIT);
 	printf("====================\n");
 	return 0;
 }
 # gcc -Wall -g -DCONFIG_STATIC_ASSERT ./testx.c ./lib/num2str.c
 # ./a.out
          1 1B
          1 1B
 ====================
         10 10B
         10 10B
 ====================
       1000 1000B
       1000 1000B
       1000 1000B
       1000 1000B
       1000 0.0KiB
       1000 1.0kB
       1000 1KiB
       1000 1kB
       1000 1KiB
       1000 1kB
 ====================
       1024 1024B
       1024 1024B
       1024 1024B
       1024 1024B
       1024 1.0KiB
       1024 1.0kB
       1024 1KiB
       1024 1kB
       1024 1KiB
       1024 1kB
 ====================
      12345 12345B
      12345 12345B
      12345 12345B
      12345 12345B
      12345 12.1KiB
      12345 12.3kB
      12345 12KiB
      12345 12kB
      12345 12KiB
      12345 12kB
      12345 0MiB
      12345 0MB
 ====================
    1234567 1234567B
    1234567 1234567B
    1234567 1234567B
    1234567 1234567B
    1234567 1205.6KiB
    1234567 1234.6kB
    1234567 1206KiB
    1234567 1235kB
    1234567 1206KiB
    1234567 1235kB
    1234567 1.2MiB
    1234567 1.2MB
    1234567 1MiB
    1234567 1MB
    1234567 1MiB
    1234567 1MB
 ====================
    1234567 1234567KiB
    1234567 1234567kB
    1234567 1234567KiB
    1234567 1234567kB
    1234567 1205.6MiB
    1234567 1234.6MB
    1234567 1206MiB
    1234567 1235MB
    1234567 1206MiB
    1234567 1235MB
    1234567 1.2GiB
    1234567 1.2GB
    1234567 1GiB
    1234567 1GB
    1234567 1GiB
    1234567 1GB
 ====================
    1234567 9876536Kibit
    1234567 9876536kbit
    1234567 9876536Kibit
    1234567 9876536kbit
    1234567 9876536Kibit
    1234567 9876536kbit
    1234567 9645.1Mibit
    1234567 9876.5Mbit
    1234567 9645Mibit
    1234567 9877Mbit
    1234567 9645Mibit
    1234567 9877Mbit
    1234567 9.4Gibit
    1234567 9.9Gbit
    1234567 9Gibit
    1234567 10Gbit
    1234567 9Gibit
    1234567 10Gbit
 ====================

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 lib/num2str.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/lib/num2str.c b/lib/num2str.c
index 448d3ff..8d08841 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -10,7 +10,7 @@
 /**
  * num2str() - Cheesy number->string conversion, complete with carry rounding error.
  * @num: quantity (e.g., number of blocks, bytes or bits)
- * @maxlen: max number of digits in the output string (not counting prefix and units)
+ * @maxlen: max number of digits in the output string (not counting prefix and units, but counting .)
  * @base: multiplier for num (e.g., if num represents Ki, use 1024)
  * @pow2: select unit prefix - 0=power-of-10 decimal SI, nonzero=power-of-2 binary IEC
  * @units: select units - N2S_* macros defined in num2str.h
@@ -23,9 +23,9 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
 	const char **unitprefix;
 	const char *unitstr[] = { "", "/s", "B", "bit", "B/s", "bit/s" };
 	const unsigned int thousand[] = { 1000, 1024 };
-	unsigned int modulo, decimals;
+	unsigned int modulo;
 	int unit_index = 0, post_index, carry = 0;
-	char tmp[32];
+	char tmp[32], fmt[32];
 	char *buf;
 
 	compiletime_assert(sizeof(sistr) == sizeof(iecstr), "unit prefix arrays must be identical sizes");
@@ -62,6 +62,9 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
 		break;
 	}
 
+	/*
+	 * Divide by K/Ki until string length of num <= maxlen.
+	 */
 	modulo = -1U;
 	while (post_index < sizeof(sistr)) {
 		sprintf(tmp, "%llu", (unsigned long long) num);
@@ -74,6 +77,9 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
 		post_index++;
 	}
 
+	/*
+	 * If no modulo, then we're done.
+	 */
 	if (modulo == -1U) {
 done:
 		if (post_index >= ARRAY_SIZE(sistr))
@@ -84,23 +90,25 @@ done:
 		return buf;
 	}
 
+	/*
+	 * If no room for decimals, then we're done.
+	 */
 	sprintf(tmp, "%llu", (unsigned long long) num);
-	decimals = maxlen - strlen(tmp);
-	if ((int)decimals <= 1) {
+	if ((int)(maxlen - strlen(tmp)) <= 1) {
 		if (carry)
 			num++;
 		goto done;
 	}
 
-	do {
-		sprintf(tmp, "%u", modulo);
-		if (strlen(tmp) <= decimals - 1)
-			break;
-
-		modulo = (modulo + 9) / 10;
-	} while (1);
+	/*
+	 * Fill in everything and return the result.
+	 */
+	assert(maxlen - strlen(tmp) - 1 > 0);
+	assert(modulo < thousand[!!pow2]);
+	sprintf(fmt, "%%.%df", (int)(maxlen - strlen(tmp) - 1));
+	sprintf(tmp, fmt, (double)modulo / (double)thousand[!!pow2]);
 
-	sprintf(buf, "%llu.%u%s%s", (unsigned long long) num, modulo,
+	sprintf(buf, "%llu.%s%s%s", (unsigned long long) num, &tmp[2],
 			unitprefix[post_index], unitstr[unit_index]);
 	return buf;
 }
-- 
2.9.3


