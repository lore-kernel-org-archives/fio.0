Return-Path: <axboe@kernel.dk>
Date: Fri, 21 Feb 2014 11:49:00 -0800
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch 3/9] fio: allow milliseconds on all time specifiers
Message-ID: <20140221194900.GA29129@kernel.dk>
References: <20140220132050.651641496@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220132050.651641496@linux.vnet.ibm.com>
To: ehrhardt@linux.vnet.ibm.com
Cc: fio@vger.kernel.org, oberpar@linux.vnet.ibm.com
List-ID: <fio@vger.kernel.org>

On Thu, Feb 20 2014, ehrhardt@linux.vnet.ibm.com wrote:
> From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
> 
> This patch allows all time specifiers to be specified down to milliseconds.
> Default will stay seconds for compatibility with old configs.
> 
> It also adds documentation to the existing time units day, hour and minute.

THis breaks default delays being in usec, it's not in msec. So if you
had some time set before on options that weren't specifically seconds,
it now would be msec instead of usec. I will commit the below to fix
this.

diff --git a/parse.c b/parse.c
index c8bae0335a4e..5c23d91ebab6 100644
--- a/parse.c
+++ b/parse.c
@@ -126,7 +126,7 @@ static unsigned long long get_mult_time(const char *str, int len)
 {
 	const char *p = str;
 	char *c;
-	unsigned long long mult = 1000;
+	unsigned long long mult = 1;
 
 	/*
          * Go forward until we hit a non-digit, or +/- sign
@@ -138,22 +138,24 @@ static unsigned long long get_mult_time(const char *str, int len)
 	}
 
 	if (!isalpha((int) *p))
-		return 1000;
+		return mult;
 
 	c = strdup(p);
 	for (int i = 0; i < strlen(c); i++)
 		c[i] = tolower(c[i]);
 
-	if (!strncmp("ms", c, 2))
+	if (!strncmp("us", c, 2) || !strncmp("usec", c, 4))
 		mult = 1;
-	else if (!strcmp("s", c))
+	else if (!strncmp("ms", c, 2) || !strncmp("msec", c, 4))
 		mult = 1000;
+	else if (!strcmp("s", c))
+		mult = 1000000;
 	else if (!strcmp("m", c))
-		mult = 60 * 1000;
+		mult = 60 * 1000000UL;
 	else if (!strcmp("h", c))
-		mult = 60 * 60 * 1000;
+		mult = 60 * 60 * 1000000UL;
 	else if (!strcmp("d", c))
-		mult = 24 * 60 * 60 * 1000;
+		mult = 24 * 60 * 60 * 1000000UL;
 
 	free(c);
 	return mult;

-- 
Jens Axboe


