Return-Path: <fio-owner@vger.kernel.org>
Received: from averel.grnet-hq.admin.grnet.gr ([195.251.29.3]:21403 "EHLO
	averel.grnet-hq.admin.grnet.gr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757097Ab3CHMwO (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 8 Mar 2013 07:52:14 -0500
From: Alex Pyrgiotis <apyrgio@grnet.gr>
Subject: [PATCH 2/2] Add a simple test for LFSR generator
Date: Fri,  8 Mar 2013 14:37:04 +0200
Message-Id: <1362746224-5162-3-git-send-email-apyrgio@grnet.gr>
In-Reply-To: <1362746224-5162-1-git-send-email-apyrgio@grnet.gr>
References: <1362746224-5162-1-git-send-email-apyrgio@grnet.gr>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: synnefo-devel@googlegroups.com

Adds a simple test suite to check the speed of the LFSR
generator and verify its results. Just run:

    make t/lfsr-test
    ./t/lfsr-test

to compile the test suite and print its usage

Signed-off-by: Alex Pyrgiotis <apyrgio@grnet.gr>

 create mode 100644 t/lfsr-test.c

diff --git a/Makefile b/Makefile
index d55626d..023557c 100644
--- a/Makefile
+++ b/Makefile
@@ -141,15 +141,21 @@ T_AXMAP_OBJS = t/axmap.o
 T_AXMAP_OBJS += lib/lfsr.o lib/axmap.o
 T_AXMAP_PROGS = t/axmap
 
+T_LFSR_TEST_OBJS = t/lfsr-test.o
+T_LFSR_TEST_OBJS += lib/lfsr.o
+T_LFSR_TEST_PROGS = t/lfsr-test
+
 T_OBJS = $(T_SMALLOC_OBJS)
 T_OBJS += $(T_IEEE_OBJS)
 T_OBJS += $(T_ZIPF_OBJS)
 T_OBJS += $(T_AXMAP_OBJS)
+T_OBJS += $(T_LFSR_TEST_OBJS)
 
 T_PROGS = $(T_SMALLOC_PROGS)
 T_PROGS += $(T_IEEE_PROGS)
 T_PROGS += $(T_ZIPF_PROGS)
 T_PROGS += $(T_AXMAP_PROGS)
+T_PROGS += $(T_LFSR_TEST_PROGS)
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
 ifndef V
@@ -204,6 +210,9 @@ t/genzipf: $(T_ZIPF_OBJS)
 t/axmap: $(T_AXMAP_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_AXMAP_OBJS) $(LIBS) $(LDFLAGS)
 
+t/lfsr-test: $(T_LFSR_TEST_OBJS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_LFSR_TEST_OBJS) $(LIBS) $(LDFLAGS)
+
 fio: $(OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(OBJS) $(LIBS) $(LDFLAGS)
 
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
new file mode 100644
index 0000000..193a7f9
--- /dev/null
+++ b/t/lfsr-test.c
@@ -0,0 +1,127 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <time.h>
+#include <math.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include "../lib/lfsr.h"
+
+void usage()
+{
+	printf("Usage: lfsr-test 0x<numbers> [seed] [spin] [verify]\n");
+	printf("-------------------------------------------------------------\n");
+	printf("*numbers: how many random numbers to produce (in hex)\n"
+		   "seed:     initial value\n"
+		   "spin:     how many iterations before we produce a number\n"
+		   "verify:   check if LFSR has iterated correctly\n\n"
+		   "Only <numbers> is required. The rest are evaluated to 0 or false\n"
+		   "Elapsed/mean time and verification results are printed at the"
+	       "end of the test\n");
+}
+
+int main(int argc, char *argv[])
+{
+	int r;
+	struct timespec start, end;
+	struct fio_lfsr *fl;
+	int verify = 0;
+	unsigned int spin = 0;
+	uint64_t seed = 0;
+	uint64_t numbers;
+	uint64_t v_size;
+	uint64_t i;
+	void *v = NULL, *v_start;
+	double total, mean;
+
+	/* Read arguments */
+	switch (argc) {
+		case 5: if (strncmp(argv[4], "verify", 7) == 0)
+					verify = 1;
+		case 4: spin = atoi(argv[3]);
+		case 3: seed = atol(argv[2]);
+		case 2: numbers = strtol(argv[1], NULL, 16);
+				break;
+		default: usage();
+				 return 1;
+	}
+
+	/* Initialize LFSR */
+	fl = malloc(sizeof(struct fio_lfsr));
+	if (!fl) {
+		perror("malloc");
+		return 1;
+	}
+
+	r = lfsr_init(fl, numbers, seed, spin);
+	if (r) {
+		printf("Initialization failed.\n");
+		return r;
+	}
+
+	/* Print specs */
+	printf("LFSR specs\n");
+	printf("==========================\n");
+	printf("Size is         %u\n", 64 - __builtin_clzl(fl->cached_bit));
+	printf("Max val is      %lu\n", fl->max_val);
+	printf("XOR-mask is     0x%lX\n", fl->xormask);
+	printf("Seed is         %lu\n", fl->last_val);
+	printf("Spin is         %u\n", fl->spin);
+	printf("Cycle length is %lu\n", fl->cycle_length);
+
+	/* Create verification table */
+	if (verify) {
+		v_size = numbers * sizeof(uint8_t);
+		v = malloc(v_size);
+		memset(v, 0, v_size);
+		printf("\nVerification table is %lf KBs\n", (double)(v_size) / 1024);
+	}
+	v_start = v;
+
+	/*
+	 * Iterate over a tight loop until we have produced all the requested
+	 * numbers. Verifying the results should introduce some small yet not
+	 * negligible overhead.
+	 */
+	fprintf(stderr, "\nTest initiated... ");
+	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);
+	while (!lfsr_next(fl, &i, fl->max_val)) {
+		if (verify)
+			*(uint8_t *)(v + i) += 1;
+	}
+	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
+	fprintf(stderr, "finished.\n");
+
+	/* Check if all expected numbers within range have been calculated */
+	r = 0;
+	if (verify) {
+		fprintf(stderr, "Verifying results... ");
+		for (i = 0; i < numbers; i++) {
+			if (*(uint8_t *)(v + 1) != 1) {
+				fprintf(stderr, "failed.\n");
+				r = 1;
+				break;
+			}
+		}
+		if (!r)
+			fprintf(stderr, "OK!\n");
+	}
+
+	/* Calculate elapsed time and mean time per number */
+	total = (end.tv_sec - start.tv_sec) * pow(10,9) +
+		end.tv_nsec - start.tv_nsec;
+	mean = total / fl->num_vals;
+
+	printf("\nTime results ");
+	if (verify)
+		printf("(slower due to verification)");
+	printf("\n==============================\n");
+	printf("Elapsed: %lf s\n", total / pow(10,9));
+	printf("Mean:    %lf ns\n", mean);
+
+	free(v_start);
+	free(fl);
+	return r;
+}
-- 
1.8.1.4

