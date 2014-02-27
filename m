Return-Path: <axboe@kernel.dk>
Date: Thu, 27 Feb 2014 09:52:08 -0800
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: cpus_allowed per thread behavior
Message-ID: <20140227175208.GB11990@kernel.dk>
References: <94D0CD8314A33A4D9D801C0FE68B4029548AB930@G9W0745.americas.hpqcorp.net>
 <530E81F6.7070305@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B4029548AB970@G9W0745.americas.hpqcorp.net>
 <530F719B.4020205@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530F719B.4020205@kernel.dk>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Feb 27 2014, Jens Axboe wrote:
> On 2014-02-26 17:12, Elliott, Robert (Server Storage) wrote:
> >>-----Original Message-----
> >>From: Jens Axboe [mailto:axboe@kernel.dk]
> >>Sent: Wednesday, 26 February, 2014 6:08 PM
> >>To: Elliott, Robert (Server Storage); fio@vger.kernel.org
> >>Subject: Re: cpus_allowed per thread behavior
> >>
> >>On 2014-02-26 15:54, Elliott, Robert (Server Storage) wrote:
> >>>fio seems to assign the same cpus_allowed/cpumask value to all threads.
> >>  > I think this allows the OS to move the threads around those CPUs.
> >>
> >>Correct. As long as the number of cpus in the mask is equal to (or
> >>larger than) the number of jobs within that group, the OS is free to
> >>place them wherever it wants. In practice, unless the CPU scheduling is
> >>horribly broken, they tend to "stick" for most intents and purposes.
> >>
> >>>In comparison, iometer assigns its worker threads to specific CPUs
> >>  > within the cpumask in round-robin manner.  Would that be worth adding
> >>  > to fio, perhaps with an option like cpus_allowed_policy=roundrobin?
> >>
> >>Sure, we could add that feature. You can get the same setup now, if you
> >>"unroll" the job section, but that might not always be practical. How
> >>about cpus_allowed_policy, with 'shared' being the existing (and
> >>default) behavior and 'split' being each thread grabbing one of the CPUs?
> >
> >Perhaps NUMA and hyperthreading aware allocation policies would
> >also be useful?
> >
> >I don't know how consistent hyperthread CPU numbering is across
> >systems.  On some servers I've tried, linux assigns 0-5 to the main
> >cores and 6-11 to the hyperthreaded siblings, while Windows assigns
> >0,2,4,6,8,10 to the main cores and 1,3,5,7,9,11 to their
> >hyperthreaded siblings.
> 
> Linux follows the firmware on that, at least as far as I know. I've
> seen machines renumber when getting a new firmware, going from the
> second scheme you list to the first. But for the below, we cannot
> assume any of them, on some machines you also have > 2 threads per
> core. So the topology would have to be queried.

Here's a test patch that implements the shared/split policy.


diff --git a/HOWTO b/HOWTO
index 4dacd98965ea..040b8a8949c6 100644
--- a/HOWTO
+++ b/HOWTO
@@ -928,6 +928,17 @@ cpus_allowed=str Controls the same options as cpumask, but it allows a text
 		allows a range of CPUs. Say you wanted a binding to CPUs
 		1, 5, and 8-15, you would set cpus_allowed=1,5,8-15.
 
+cpus_allowed_policy=str Set the policy of how fio distributes the CPUs
+		specified by cpus_allowed or cpumask. Two policies are
+		supported:
+
+		shared	All jobs will share the CPU set specified.
+		split	Each job will get a unique CPU from the CPU set.
+
+		If shared is the default behaviour, if the option isn't
+		specified. If split is specified, then fio will error out if
+		there are more jobs defined than CPUs given in the set.
+
 numa_cpu_nodes=str Set this job running on spcified NUMA nodes' CPUs. The
 		arguments allow comma delimited list of cpu numbers,
 		A-B ranges, or 'all'. Note, to enable numa options support,
diff --git a/backend.c b/backend.c
index ee395bd0ea57..12c76d8545ef 100644
--- a/backend.c
+++ b/backend.c
@@ -1278,6 +1278,15 @@ static void *thread_main(void *data)
 	 * allocations.
 	 */
 	if (o->cpumask_set) {
+		if (o->cpus_allowed_policy == FIO_CPUS_SPLIT) {
+			ret = fio_cpus_split(&o->cpumask, td->thread_number);
+			if (!ret) {
+				log_err("fio: no CPUs set\n");
+				log_err("fio: Try increasing number of available CPUs\n");
+				td_verror(td, EINVAL, "cpus_split");
+				goto err;
+			}
+		}
 		ret = fio_setaffinity(td->pid, o->cpumask);
 		if (ret == -1) {
 			td_verror(td, errno, "cpu_set_affinity");
diff --git a/cconv.c b/cconv.c
index fd8d0ad85142..357a7845e559 100644
--- a/cconv.c
+++ b/cconv.c
@@ -188,6 +188,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->numjobs = le32_to_cpu(top->numjobs);
 	o->cpumask_set = le32_to_cpu(top->cpumask_set);
 	o->verify_cpumask_set = le32_to_cpu(top->verify_cpumask_set);
+	o->cpus_allowed_policy = le32_to_cpu(top->cpus_allowed_policy);
 	o->iolog = le32_to_cpu(top->iolog);
 	o->rwmixcycle = le32_to_cpu(top->rwmixcycle);
 	o->nice = le32_to_cpu(top->nice);
@@ -343,6 +344,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->numjobs = cpu_to_le32(o->numjobs);
 	top->cpumask_set = cpu_to_le32(o->cpumask_set);
 	top->verify_cpumask_set = cpu_to_le32(o->verify_cpumask_set);
+	top->cpus_allowed_policy = cpu_to_le32(o->cpus_allowed_policy);
 	top->iolog = cpu_to_le32(o->iolog);
 	top->rwmixcycle = cpu_to_le32(o->rwmixcycle);
 	top->nice = cpu_to_le32(o->nice);
diff --git a/fio.1 b/fio.1
index c530d8440cd0..294e3836b4e5 100644
--- a/fio.1
+++ b/fio.1
@@ -833,6 +833,23 @@ may run on.  See \fBsched_setaffinity\fR\|(2).
 .BI cpus_allowed \fR=\fPstr
 Same as \fBcpumask\fR, but allows a comma-delimited list of CPU numbers.
 .TP
+.BI cpus_allowed_policy \fR=\fPstr
+Set the policy of how fio distributes the CPUs specified by \fBcpus_allowed\fR
+or \fBcpumask\fR. Two policies are supported:
+.RS
+.RS
+.TP
+.B shared
+All jobs will share the CPU set specified.
+.TP
+.B split
+Each job will get a unique CPU from the CPU set.
+.RE
+.P
+If \fBshared\fR is the default behaviour, if the option isn't specified. If
+\fBsplit\fR is specified, then fio will error out if there are more jobs
+defined than CPUs given in the set.
+.TP
 .BI numa_cpu_nodes \fR=\fPstr
 Set this job running on specified NUMA nodes' CPUs. The arguments allow
 comma delimited list of cpu numbers, A-B ranges, or 'all'.
diff --git a/fio.h b/fio.h
index 9159b0c2de3e..6f5f29fb3a97 100644
--- a/fio.h
+++ b/fio.h
@@ -629,4 +629,9 @@ enum {
 	FIO_RAND_GEN_LFSR,
 };
 
+enum {
+	FIO_CPUS_SHARED		= 0,
+	FIO_CPUS_SPLIT,
+};
+
 #endif
diff --git a/options.c b/options.c
index 6d3956e307bf..c1a8f323e956 100644
--- a/options.c
+++ b/options.c
@@ -394,6 +394,21 @@ static int str_exitall_cb(void)
 }
 
 #ifdef FIO_HAVE_CPU_AFFINITY
+int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu)
+{
+	const long max_cpu = cpus_online();
+	unsigned int i;
+
+	for (i = 0; i < max_cpu; i++) {
+		if (cpu != i) {
+			fio_cpu_clear(mask, i);
+			continue;
+		}
+	}
+
+	return fio_cpu_count(mask);
+}
+
 static int str_cpumask_cb(void *data, unsigned long long *val)
 {
 	struct thread_data *td = data;
@@ -2875,6 +2890,27 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
 	},
+	{
+		.name	= "cpus_allowed_policy",
+		.lname	= "CPUs allowed distribution policy",
+		.type	= FIO_OPT_STR,
+		.off1	= td_var_offset(cpus_allowed_policy),
+		.help	= "Distribution policy for cpus_allowed",
+		.parent = "cpus_allowed",
+		.prio	= 1,
+		.posval = {
+			  { .ival = "shared",
+			    .oval = FIO_CPUS_SHARED,
+			    .help = "Mask shared between threads",
+			  },
+			  { .ival = "split",
+			    .oval = FIO_CPUS_SPLIT,
+			    .help = "Mask split between threads",
+			  },
+		},
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_CRED,
+	},
 #endif
 #ifdef CONFIG_LIBNUMA
 	{
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index 57ce409c67fd..402792a0f7d7 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -32,6 +32,7 @@ typedef cpuset_t os_cpu_mask_t;
 
 #define fio_cpu_clear(mask, cpu)        (void) CPU_CLR((cpu), (mask))
 #define fio_cpu_set(mask, cpu)          (void) CPU_SET((cpu), (mask))
+#define fio_cpu_count(maks)		CPU_COUNT((mask))
 
 static inline int fio_cpuset_init(os_cpu_mask_t *mask)
 {
diff --git a/os/os-linux.h b/os/os-linux.h
index 5d1d62db27a0..3ed8c2ef31f2 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -61,6 +61,7 @@ typedef struct drand48_data os_random_state_t;
 
 #define fio_cpu_clear(mask, cpu)	(void) CPU_CLR((cpu), (mask))
 #define fio_cpu_set(mask, cpu)		(void) CPU_SET((cpu), (mask))
+#define fio_cpu_count(maks)		CPU_COUNT((mask))
 
 static inline int fio_cpuset_init(os_cpu_mask_t *mask)
 {
diff --git a/os/os-solaris.h b/os/os-solaris.h
index e6612118ace4..7a0a3f0bfeca 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -111,6 +111,16 @@ static inline int fio_cpuset_init(os_cpu_mask_t *mask)
 	return 0;
 }
 
+static inline int fio_cpuset_count(os_cpu_mask_t *mask)
+{
+	unsigned int num_cpus;
+
+	if (pset_info(*mask, NULL, &num_cpus, NULL) < 0)
+		return 0;
+
+	return num_cpus;
+}
+
 static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
 {
 	if (pset_destroy(*mask) < 0)
diff --git a/os/os-windows.h b/os/os-windows.h
index de120b64ff7e..7bfe3d2255e4 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -214,6 +214,11 @@ static inline void fio_cpu_set(os_cpu_mask_t *mask, int cpu)
 	*mask |= 1 << cpu;
 }
 
+static inline int fio_cpu_count(os_cpu_mask_t *mask, int cpu)
+{
+	return hweight64(*mask);
+}
+
 static inline int fio_cpuset_init(os_cpu_mask_t *mask)
 {
 	*mask = 0;
diff --git a/os/os.h b/os/os.h
index 03d1e9a14565..a6bc17f09b57 100644
--- a/os/os.h
+++ b/os/os.h
@@ -80,7 +80,10 @@ typedef struct aiocb os_aiocb_t;
 #define fio_getaffinity(pid, mask)	do { } while (0)
 #define fio_cpu_clear(mask, cpu)	do { } while (0)
 #define fio_cpuset_exit(mask)		(-1)
+#define fio_cpus_split(mask, cpu)	(0)
 typedef unsigned long os_cpu_mask_t;
+#else
+extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #endif
 
 #ifndef FIO_HAVE_IOPRIO
diff --git a/thread_options.h b/thread_options.h
index 14a4e54abcc7..4ea6ebd06a0c 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -155,6 +155,7 @@ struct thread_options {
 	unsigned int cpumask_set;
 	os_cpu_mask_t verify_cpumask;
 	unsigned int verify_cpumask_set;
+	unsigned int cpus_allowed_policy;
 #ifdef CONFIG_LIBNUMA
 	struct bitmask *numa_cpunodesmask;
 	unsigned int numa_cpumask_set;
@@ -378,6 +379,7 @@ struct thread_options_pack {
 	uint32_t cpumask_set;
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
 	uint32_t verify_cpumask_set;
+	uint32_t cpus_allowed_policy;
 	uint32_t iolog;
 	uint32_t rwmixcycle;
 	uint32_t rwmix[DDIR_RWDIR_CNT];

-- 
Jens Axboe


