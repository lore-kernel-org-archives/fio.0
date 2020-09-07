Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Mon, 7 Sep 2020 20:59:23 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] fio: cap io_size=N% at 100%, update man page
Message-ID: <20200907175923.GA86772@localhost.localdomain>
References: <20200903165402.GA78826@localhost.localdomain>
 <CALjAwxhqaRPUGjyUapVM=cOqGTQSBb_wvSNQKe=k+eNGW6dL3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALjAwxhqaRPUGjyUapVM=cOqGTQSBb_wvSNQKe=k+eNGW6dL3w@mail.gmail.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, sitsofe@gmail.com
List-ID: <fio@vger.kernel.org>

Passing io_size > 100% results in semi-infinite loop, anyway.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---

 fio.1     |    3 ++-
 options.c |    6 +++++-
 parse.h   |    5 +++++
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/fio.1
+++ b/fio.1
@@ -1561,7 +1561,8 @@ if \fBsize\fR is set to 20GiB and \fBio_size\fR is set to 5GiB, fio
 will perform I/O within the first 20GiB but exit when 5GiB have been
 done. The opposite is also possible \-\- if \fBsize\fR is set to 20GiB,
 and \fBio_size\fR is set to 40GiB, then fio will do 40GiB of I/O within
-the 0..20GiB region.
+the 0..20GiB region. Value can be set as percentage: \fBio_size\fR=N%.
+In this case \fBio_size\fR multiplies \fBsize\fR= value.
 .TP
 .BI filesize \fR=\fPirange(int)
 Individual file sizes. May be a range, in which case fio will select sizes
--- a/options.c
+++ b/options.c
@@ -1481,9 +1481,13 @@ static int str_io_size_cb(void *data, unsigned long long *__val)
 	struct thread_data *td = cb_data_to_td(data);
 	unsigned long long v = *__val;
 
-	if (parse_is_percent(v)) {
+	if (parse_is_percent_uncapped(v)) {
 		td->o.io_size = 0;
 		td->o.io_size_percent = -1ULL - v;
+		if (td->o.io_size_percent > 100) {
+			log_err("fio: io_size values greater than 100%% aren't supported\n");
+			return 1;
+		}
 		dprint(FD_PARSE, "SET io_size_percent %d\n",
 					td->o.io_size_percent);
 	} else
--- a/parse.h
+++ b/parse.h
@@ -133,6 +133,11 @@ static inline int parse_is_percent(unsigned long long val)
 	return val <= -1ULL && val >= (-1ULL - 100ULL);
 }
 
+static inline int parse_is_percent_uncapped(unsigned long long val)
+{
+	return (long long)val <= -1;
+}
+
 struct print_option {
 	struct flist_head list;
 	char *name;

