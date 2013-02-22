Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56254
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756101Ab3BVTe2 (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 22 Feb 2013 14:34:28 -0500
Date: Fri, 22 Feb 2013 20:32:50 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Output logs and keep command line display
Message-ID: <20130222193250.GE25064@kernel.dk>
References: <CANUChTxynLg7p5kK1vex9965qvYxyFagzk8QAtbh-2-=_Mdxhg@mail.gmail.com>
 <20130131140223.GI8800@kernel.dk>
 <20130131140854.GJ8800@kernel.dk>
 <CANUChTwu9UJt1rYSb4JZ-URXVpDmEnTmteApGRcasJM06nR0ow@mail.gmail.com>
 <20130131142425.GK8800@kernel.dk>
 <CANUChTxnudOx6B3HjWfbD36Cq31eGTA3W2+qbGDYLjr+sJP4cw@mail.gmail.com>
 <20130222120759.GU25617@kernel.dk>
 <A7A1D348E34E024BBC74480FB93A2EAB014104@DAGN05A-E6.exg6.exghost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB014104@DAGN05A-E6.exg6.exghost.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Feb 22 2013, Carl Zwanzig wrote:
> While we're on the subject-
> 
> For some long-running tests*, I hacked the ETA display to appear every 60 seconds and with a trailing newline. This isn't much of a code change, but since I haven't figured out how the option processing works, I haven't created a patch.
> 
> * Needed to watch the write speed over the entire range of a 3tb drive. On some drives, it drops quite a bit from low LBAs to high ones.

Something like the below should do the trick, you should be able to use
either --eta-newline=60s or --eta-newline=1m to get that behavior. It
also shows you how to add a command line option, which are different
from the job options. So now you know! In general, if in doubt on how to
add a new option, it helps a lot to browse git log for a commit that
added a new option. Eg do git log init.c, find the first commit, then
run a git show on that commit id. For a job options, do the same but use
options.c instead.

Let me know how it works for you and I will get it committed.

diff --git a/README b/README
index 4f796e3..b662e71 100644
--- a/README
+++ b/README
@@ -152,6 +152,7 @@ $ fio
 				writes
 	--eta=when		When ETA estimate should be printed
 				May be "always", "never" or "auto"
+	--eta-newline=time	Force a new line for every 'time' period passed
 	--section=name		Only run specified section in job file.
 				Multiple sections can be specified.
 	--alloc-size=kb		Set smalloc pool to this size in kb (def 1024)
diff --git a/eta.c b/eta.c
index 5ef31c6..f90d428 100644
--- a/eta.c
+++ b/eta.c
@@ -422,12 +422,13 @@ int calc_thread_status(struct jobs_eta *je, int force)
 
 	je->nr_threads = thread_number;
 	memcpy(je->run_str, run_str, thread_number * sizeof(char));
-
 	return 1;
 }
 
 void display_thread_status(struct jobs_eta *je)
 {
+	static struct timeval disp_eta_new_line;
+	static int eta_new_line_init, eta_new_line_pending;
 	static int linelen_last;
 	static int eta_good;
 	char output[REAL_MAX_JOBS + 512], *p = output;
@@ -439,6 +440,11 @@ void display_thread_status(struct jobs_eta *je)
 		eta_to_str(eta_str, je->eta_sec);
 	}
 
+	if (eta_new_line_pending) {
+		eta_new_line_pending = 0;
+		p += sprintf(p, "\n");
+	}
+
 	p += sprintf(p, "Jobs: %d (f=%d)", je->nr_running, je->files_open);
 	if (je->m_rate || je->t_rate) {
 		char *tr, *mr;
@@ -492,6 +498,16 @@ void display_thread_status(struct jobs_eta *je)
 	p += sprintf(p, "\r");
 
 	printf("%s", output);
+
+	if (!eta_new_line_init) {
+		fio_gettime(&disp_eta_new_line, NULL);
+		eta_new_line_init = 1;
+	} else if (eta_new_line &&
+		   mtime_since_now(&disp_eta_new_line) > eta_new_line * 1000) {
+		fio_gettime(&disp_eta_new_line, NULL);
+		eta_new_line_pending = 1;
+	}
+
 	fflush(stdout);
 }
 
diff --git a/fio.h b/fio.h
index 43f4854..d7eb6de 100644
--- a/fio.h
+++ b/fio.h
@@ -594,6 +594,7 @@ extern unsigned long long mlock_size;
 extern uintptr_t page_mask, page_size;
 extern int read_only;
 extern int eta_print;
+extern int eta_new_line;
 extern unsigned long done_secs;
 extern char *job_section;
 extern int fio_gtod_offload;
diff --git a/init.c b/init.c
index 4709ff2..32da42c 100644
--- a/init.c
+++ b/init.c
@@ -41,6 +41,7 @@ struct thread_data *threads = NULL;
 int exitall_on_terminate = 0;
 int output_format = FIO_OUTPUT_NORMAL;
 int eta_print = FIO_ETA_AUTO;
+int eta_new_line = 0;
 unsigned long long mlock_size = 0;
 FILE *f_out = NULL;
 FILE *f_err = NULL;
@@ -140,6 +141,11 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'e' | FIO_CLIENT_FLAG,
 	},
 	{
+		.name		= (char *) "eta-newline",
+		.has_arg	= required_argument,
+		.val		= 'E' | FIO_CLIENT_FLAG,
+	},
+	{
 		.name		= (char *) "debug",
 		.has_arg	= required_argument,
 		.val		= 'd' | FIO_CLIENT_FLAG,
@@ -1264,6 +1270,8 @@ static void usage(const char *name)
 	printf("  --showcmd\t\tTurn a job file into command line options\n");
 	printf("  --eta=when\t\tWhen ETA estimate should be printed\n");
 	printf("            \t\tMay be \"always\", \"never\" or \"auto\"\n");
+	printf("  --eta-newline=time\tForce a new line for every 'time'");
+	printf(" period passed\n");
 	printf("  --readonly\t\tTurn on safety read-only checks, preventing"
 		" writes\n");
 	printf("  --section=name\tOnly run specified section in job file\n");
@@ -1505,6 +1513,17 @@ int parse_cmd_line(int argc, char *argv[])
 			else if (!strcmp("never", optarg))
 				eta_print = FIO_ETA_NEVER;
 			break;
+		case 'E': {
+			long long t = 0;
+
+			if (str_to_decimal(optarg, &t, 0, NULL)) {
+				log_err("fio: failed parsing eta time %s\n", optarg);
+				exit_val = 1;
+				do_exit++;
+			}
+			eta_new_line = t;
+			break;
+			}
 		case 'd':
 			if (set_debug(optarg))
 				do_exit++;

-- 
Jens Axboe

