Return-Path: <evelu@redhat.com>
Date: Mon, 8 Aug 2016 09:31:19 -0400 (EDT)
From: Erwan Velu <evelu@redhat.com>
Message-ID: <415126992.423440.1470663079681.JavaMail.zimbra@redhat.com>
In-Reply-To: <20160808120002.427E02C00A2@kernel.dk>
References: <20160808120002.427E02C00A2@kernel.dk>
Subject: Re: Recent changes (master)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hey Jens,

Isn't that dangerous to sum many unsigned integers into a signed int ?
Couldn't this trigger overflows ?
+                sum +=3D io_u_plat[j + k];

----- Mail original -----
De: "Jens Axboe" <axboe@kernel.dk>
=C3=80: fio@vger.kernel.org
Envoy=C3=A9: Lundi 8 Ao=C3=BBt 2016 14:00:02
Objet: Recent changes (master)

The following changes since commit 5fd31680d0370c6b71ccfa456ade211477af81d6=
:

  Revert "filesetup: ensure that we catch a file flagged for extend" (2016-=
08-04 19:41:09 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 93168285bc564941d832deea172dc1f68de68666:

  stat: fixups to histogram logging (2016-08-07 15:18:38 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Merge branch 'histograms-PR' of https://github.com/cronburg/fio
      server: bump protocol version
      iolog: style updates
      stat: fixups to histogram logging

Karl Cronburg (1):
      This commit / feature adds completion latency histogram output to fio=
, piggybacking     on the existing histograms recorded by stat.c and adding=
 the following command     line options:

 HOWTO                           |  22 ++
 cconv.c                         |   5 +
 fio.1                           |  29 +++
 fio.h                           |   1 +
 init.c                          |  36 +++
 iolog.c                         |  73 +++++-
 iolog.h                         |  16 ++
 options.c                       |  31 +++
 server.h                        |   2 +-
 stat.c                          |  40 ++++
 thread_options.h                |   6 +
 tools/hist/.gitignore           |   3 +
 tools/hist/fiologparser_hist.py | 486 ++++++++++++++++++++++++++++++++++++=
++++
 tools/hist/half-bins.py         |  38 ++++
 14 files changed, 785 insertions(+), 3 deletions(-)
 create mode 100644 tools/hist/.gitignore
 create mode 100755 tools/hist/fiologparser_hist.py
 create mode 100755 tools/hist/half-bins.py

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index d18d59b..0085b74 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1610,6 +1610,14 @@ write_lat_log=3Dstr Same as write_bw_log, except tha=
t this option stores io
 =09=09the filename will not include the job index. See 'Log File
 =09=09Formats'.
=20
+write_hist_log=3Dstr Same as write_lat_log, but writes I/O completion
+=09=09latency histograms. If no filename is given with this option, the
+=09=09default filename of "jobname_clat_hist.x.log" is used, where x is
+=09=09the index of the job (1..N, where N is the number of jobs). Even
+=09=09if the filename is given, fio will still append the type of log.
+=09=09If per_job_logs is false, then the filename will not include the
+=09=09job index. See 'Log File Formats'.
+
 write_iops_log=3Dstr Same as write_bw_log, but writes IOPS. If no filename=
 is
 =09=09given with this option, the default filename of
 =09=09"jobname_type.x.log" is used,where x is the index of the job
@@ -1625,6 +1633,20 @@ log_avg_msec=3Dint By default, fio will log an entry=
 in the iops, latency,
 =09=09specified period of time, reducing the resolution of the log.
 =09=09See log_max_value as well. Defaults to 0, logging all entries.
=20
+log_hist_msec=3Dint Same as log_avg_msec, but logs entries for completion
+=09=09latency histograms. Computing latency percentiles from averages of
+=09=09intervals using log_avg_msec is innacurate. Setting this option make=
s
+=09=09fio log histogram entries over the specified period of time, reducin=
g
+=09=09log sizes for high IOPS devices while retaining percentile accuracy.
+=09=09See log_hist_coarseness as well. Defaults to 0, meaning histogram
+=09=09logging is disabled.
+
+log_hist_coarseness=3Dint Integer ranging from 0 to 6, defining the coarse=
ness
+=09=09of the resolution of the histogram logs enabled with log_hist_msec. =
For
+=09=09each increment in coarseness, fio outputs half as many bins. Default=
s to
+=09=090, for which histogram logs contain 1216 latency bins. See
+=09=09'Log File Formats'.
+
 log_max_value=3Dbool=09If log_avg_msec is set, fio logs the average over t=
hat
 =09=09window. If you instead want to log the maximum value, set this
 =09=09option to 1. Defaults to 0, meaning that averaged values are
diff --git a/cconv.c b/cconv.c
index ac826a3..837963d 100644
--- a/cconv.c
+++ b/cconv.c
@@ -39,6 +39,7 @@ static void free_thread_options_to_cpu(struct thread_opti=
ons *o)
 =09free(o->bw_log_file);
 =09free(o->lat_log_file);
 =09free(o->iops_log_file);
+=09free(o->hist_log_file);
 =09free(o->replay_redirect);
 =09free(o->exec_prerun);
 =09free(o->exec_postrun);
@@ -74,6 +75,7 @@ void convert_thread_options_to_cpu(struct thread_options =
*o,
 =09string_to_cpu(&o->bw_log_file, top->bw_log_file);
 =09string_to_cpu(&o->lat_log_file, top->lat_log_file);
 =09string_to_cpu(&o->iops_log_file, top->iops_log_file);
+=09string_to_cpu(&o->hist_log_file, top->hist_log_file);
 =09string_to_cpu(&o->replay_redirect, top->replay_redirect);
 =09string_to_cpu(&o->exec_prerun, top->exec_prerun);
 =09string_to_cpu(&o->exec_postrun, top->exec_postrun);
@@ -178,6 +180,8 @@ void convert_thread_options_to_cpu(struct thread_option=
s *o,
 =09o->allrand_repeatable =3D le32_to_cpu(top->allrand_repeatable);
 =09o->rand_seed =3D le64_to_cpu(top->rand_seed);
 =09o->log_avg_msec =3D le32_to_cpu(top->log_avg_msec);
+=09o->log_hist_msec =3D le32_to_cpu(top->log_hist_msec);
+=09o->log_hist_coarseness =3D le32_to_cpu(top->log_hist_coarseness);
 =09o->log_max =3D le32_to_cpu(top->log_max);
 =09o->log_offset =3D le32_to_cpu(top->log_offset);
 =09o->log_gz =3D le32_to_cpu(top->log_gz);
@@ -309,6 +313,7 @@ void convert_thread_options_to_net(struct thread_option=
s_pack *top,
 =09string_to_net(top->bw_log_file, o->bw_log_file);
 =09string_to_net(top->lat_log_file, o->lat_log_file);
 =09string_to_net(top->iops_log_file, o->iops_log_file);
+=09string_to_net(top->hist_log_file, o->hist_log_file);
 =09string_to_net(top->replay_redirect, o->replay_redirect);
 =09string_to_net(top->exec_prerun, o->exec_prerun);
 =09string_to_net(top->exec_postrun, o->exec_postrun);
diff --git a/fio.1 b/fio.1
index 85eb0fe..d1acebc 100644
--- a/fio.1
+++ b/fio.1
@@ -1476,6 +1476,14 @@ N is the number of jobs). Even if the filename is gi=
ven, fio will still
 append the type of log. If \fBper_job_logs\fR is false, then the filename =
will
 not include the job index. See the \fBLOG FILE FORMATS\fR section.
 .TP
+.BI write_hist_log \fR=3D\fPstr
+Same as \fBwrite_lat_log\fR, but writes I/O completion latency histograms.=
 If
+no filename is given with this option, the default filename of
+"jobname_clat_hist.x.log" is used, where x is the index of the job (1..N, =
where
+N is the number of jobs). Even if the filename is given, fio will still ap=
pend
+the type of log. If \fBper_job_logs\fR is false, then the filename will no=
t
+include the job index. See the \fBLOG FILE FORMATS\fR section.
+.TP
 .BI write_iops_log \fR=3D\fPstr
 Same as \fBwrite_bw_log\fR, but writes IOPS. If no filename is given with =
this
 option, the default filename of "jobname_type.x.log" is used, where x is t=
he
@@ -1496,6 +1504,20 @@ If \fBlog_avg_msec\fR is set, fio logs the average o=
ver that window. If you
 instead want to log the maximum value, set this option to 1.  Defaults to
 0, meaning that averaged values are logged.
 .TP
+.BI log_hist_msec \fR=3D\fPint
+Same as \fBlog_avg_msec\fR, but logs entries for completion latency histog=
rams.
+Computing latency percentiles from averages of intervals using \fBlog_avg_=
msec\fR
+is innacurate. Setting this option makes fio log histogram entries over th=
e
+specified period of time, reducing log sizes for high IOPS devices while
+retaining percentile accuracy. See \fBlog_hist_coarseness\fR as well. Defa=
ults
+to 0, meaning histogram logging is disabled.
+.TP
+.BI log_hist_coarseness \fR=3D\fPint
+Integer ranging from 0 to 6, defining the coarseness of the resolution of =
the
+histogram logs enabled with \fBlog_hist_msec\fR. For each increment in
+coarseness, fio outputs half as many bins. Defaults to 0, for which histog=
ram
+logs contain 1216 latency bins. See the \fBLOG FILE FORMATS\fR section.
+.TP
 .BI log_offset \fR=3D\fPbool
 If this is set, the iolog options will include the byte offset for the IO
 entry as well as the other data values.
@@ -2302,6 +2324,13 @@ they aren't applicable if windowed logging is enable=
d. If windowed logging
 is enabled and \fBlog_max_value\fR is set, then fio logs maximum values in
 that window instead of averages.
=20
+For histogram logging the logs look like this:
+
+.B time (msec), data direction, block-size, bin 0, bin 1, ..., bin 1215
+
+Where 'bin i' gives the frequency of IO requests with a latency falling in
+the i-th bin. See \fBlog_hist_coarseness\fR for logging fewer bins.
+
 .RE
=20
 .SH CLIENT / SERVER
diff --git a/fio.h b/fio.h
index 87a94f6..d929467 100644
--- a/fio.h
+++ b/fio.h
@@ -141,6 +141,7 @@ struct thread_data {
=20
 =09struct io_log *slat_log;
 =09struct io_log *clat_log;
+=09struct io_log *clat_hist_log;
 =09struct io_log *lat_log;
 =09struct io_log *bw_log;
 =09struct io_log *iops_log;
diff --git a/init.c b/init.c
index f81db3c..048bd5d 100644
--- a/init.c
+++ b/init.c
@@ -1418,6 +1418,8 @@ static int add_job(struct thread_data *td, const char=
 *jobname, int job_add_num,
 =09=09struct log_params p =3D {
 =09=09=09.td =3D td,
 =09=09=09.avg_msec =3D o->log_avg_msec,
+=09=09=09.hist_msec =3D o->log_hist_msec,
+=09=09=09.hist_coarseness =3D o->log_hist_coarseness,
 =09=09=09.log_type =3D IO_LOG_TYPE_LAT,
 =09=09=09.log_offset =3D o->log_offset,
 =09=09=09.log_gz =3D o->log_gz,
@@ -1442,10 +1444,36 @@ static int add_job(struct thread_data *td, const ch=
ar *jobname, int job_add_num,
 =09=09=09=09td->thread_number, suf, o->per_job_logs);
 =09=09setup_log(&td->clat_log, &p, logname);
 =09}
+
+=09if (o->hist_log_file) {
+=09=09struct log_params p =3D {
+=09=09=09.td =3D td,
+=09=09=09.avg_msec =3D o->log_avg_msec,
+=09=09=09.hist_msec =3D o->log_hist_msec,
+=09=09=09.hist_coarseness =3D o->log_hist_coarseness,
+=09=09=09.log_type =3D IO_LOG_TYPE_HIST,
+=09=09=09.log_offset =3D o->log_offset,
+=09=09=09.log_gz =3D o->log_gz,
+=09=09=09.log_gz_store =3D o->log_gz_store,
+=09=09};
+=09=09const char *suf;
+
+=09=09if (p.log_gz_store)
+=09=09=09suf =3D "log.fz";
+=09=09else
+=09=09=09suf =3D "log";
+
+=09=09gen_log_name(logname, sizeof(logname), "clat_hist", o->hist_log_file=
,
+=09=09=09=09td->thread_number, suf, o->per_job_logs);
+=09=09setup_log(&td->clat_hist_log, &p, logname);
+=09}
+
 =09if (o->bw_log_file) {
 =09=09struct log_params p =3D {
 =09=09=09.td =3D td,
 =09=09=09.avg_msec =3D o->log_avg_msec,
+=09=09=09.hist_msec =3D o->log_hist_msec,
+=09=09=09.hist_coarseness =3D o->log_hist_coarseness,
 =09=09=09.log_type =3D IO_LOG_TYPE_BW,
 =09=09=09.log_offset =3D o->log_offset,
 =09=09=09.log_gz =3D o->log_gz,
@@ -1457,6 +1485,9 @@ static int add_job(struct thread_data *td, const char=
 *jobname, int job_add_num,
 =09=09=09p.avg_msec =3D min(o->log_avg_msec, o->bw_avg_time);
 =09=09else
 =09=09=09o->bw_avg_time =3D p.avg_msec;
+=09
+=09=09p.hist_msec =3D o->log_hist_msec;
+=09=09p.hist_coarseness =3D o->log_hist_coarseness;
=20
 =09=09if (p.log_gz_store)
 =09=09=09suf =3D "log.fz";
@@ -1471,6 +1502,8 @@ static int add_job(struct thread_data *td, const char=
 *jobname, int job_add_num,
 =09=09struct log_params p =3D {
 =09=09=09.td =3D td,
 =09=09=09.avg_msec =3D o->log_avg_msec,
+=09=09=09.hist_msec =3D o->log_hist_msec,
+=09=09=09.hist_coarseness =3D o->log_hist_coarseness,
 =09=09=09.log_type =3D IO_LOG_TYPE_IOPS,
 =09=09=09.log_offset =3D o->log_offset,
 =09=09=09.log_gz =3D o->log_gz,
@@ -1482,6 +1515,9 @@ static int add_job(struct thread_data *td, const char=
 *jobname, int job_add_num,
 =09=09=09p.avg_msec =3D min(o->log_avg_msec, o->iops_avg_time);
 =09=09else
 =09=09=09o->iops_avg_time =3D p.avg_msec;
+=09
+=09=09p.hist_msec =3D o->log_hist_msec;
+=09=09p.hist_coarseness =3D o->log_hist_coarseness;
=20
 =09=09if (p.log_gz_store)
 =09=09=09suf =3D "log.fz";
diff --git a/iolog.c b/iolog.c
index 4c87f1c..a9cbd5b 100644
--- a/iolog.c
+++ b/iolog.c
@@ -584,6 +584,8 @@ void setup_log(struct io_log **log, struct log_params *=
p,
 =09l->log_gz =3D p->log_gz;
 =09l->log_gz_store =3D p->log_gz_store;
 =09l->avg_msec =3D p->avg_msec;
+=09l->hist_msec =3D p->hist_msec;
+=09l->hist_coarseness =3D p->hist_coarseness;
 =09l->filename =3D strdup(filename);
 =09l->td =3D p->td;
=20
@@ -659,6 +661,48 @@ void free_log(struct io_log *log)
 =09sfree(log);
 }
=20
+static inline int hist_sum(int j, int stride, unsigned int *io_u_plat)
+{
+=09int k, sum;
+
+=09for (k =3D sum =3D 0; k < stride; k++)
+=09=09sum +=3D io_u_plat[j + k];
+
+=09return sum;
+}
+
+void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
+=09=09=09uint64_t sample_size)
+{
+=09struct io_sample *s;
+=09int log_offset;
+=09uint64_t i, j, nr_samples;
+=09unsigned int *io_u_plat;
+
+=09int stride =3D 1 << hist_coarseness;
+=09
+=09if (!sample_size)
+=09=09return;
+
+=09s =3D __get_sample(samples, 0, 0);
+=09log_offset =3D (s->__ddir & LOG_OFFSET_SAMPLE_BIT) !=3D 0;
+
+=09nr_samples =3D sample_size / __log_entry_sz(log_offset);
+
+=09for (i =3D 0; i < nr_samples; i++) {
+=09=09s =3D __get_sample(samples, log_offset, i);
+=09=09io_u_plat =3D (unsigned int *) s->val;
+=09=09fprintf(f, "%lu, %u, %u, ", (unsigned long)s->time,
+=09=09        io_sample_ddir(s), s->bs);
+=09=09for (j =3D 0; j < FIO_IO_U_PLAT_NR - stride; j +=3D stride) {
+=09=09=09fprintf(f, "%lu, ", (unsigned long) hist_sum(j, stride, io_u_plat=
));=20
+=09=09}
+=09=09fprintf(f, "%lu\n", (unsigned long)=20
+=09=09        hist_sum(FIO_IO_U_PLAT_NR - stride, stride, io_u_plat));
+=09=09free(io_u_plat);
+=09}
+}
+
 void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 {
 =09struct io_sample *s;
@@ -988,7 +1032,13 @@ void flush_log(struct io_log *log, bool do_append)
=20
 =09=09cur_log =3D flist_first_entry(&log->io_logs, struct io_logs, list);
 =09=09flist_del_init(&cur_log->list);
-=09=09flush_samples(f, cur_log->log, cur_log->nr_samples * log_entry_sz(lo=
g));
+=09=09
+=09=09if (log =3D=3D log->td->clat_hist_log)
+=09=09=09flush_hist_samples(f, log->hist_coarseness, cur_log->log,
+=09=09=09                   cur_log->nr_samples * log_entry_sz(log));
+=09=09else
+=09=09=09flush_samples(f, cur_log->log, cur_log->nr_samples * log_entry_sz=
(log));
+=09=09
 =09=09sfree(cur_log);
 =09}
=20
@@ -1353,6 +1403,20 @@ static int write_clat_log(struct thread_data *td, in=
t try, bool unit_log)
 =09return ret;
 }
=20
+static int write_clat_hist_log(struct thread_data *td, int try, bool unit_=
log)
+{
+=09int ret;
+
+=09if (!unit_log)
+=09=09return 0;
+
+=09ret =3D __write_log(td, td->clat_hist_log, try);
+=09if (!ret)
+=09=09td->clat_hist_log =3D NULL;
+
+=09return ret;
+}
+
 static int write_lat_log(struct thread_data *td, int try, bool unit_log)
 {
 =09int ret;
@@ -1387,8 +1451,9 @@ enum {
 =09SLAT_LOG_MASK=09=3D 4,
 =09CLAT_LOG_MASK=09=3D 8,
 =09IOPS_LOG_MASK=09=3D 16,
+=09CLAT_HIST_LOG_MASK =3D 32,
=20
-=09ALL_LOG_NR=09=3D 5,
+=09ALL_LOG_NR=09=3D 6,
 };
=20
 struct log_type {
@@ -1417,6 +1482,10 @@ static struct log_type log_types[] =3D {
 =09=09.mask=09=3D IOPS_LOG_MASK,
 =09=09.fn=09=3D write_iops_log,
 =09},
+=09{
+=09=09.mask=09=3D CLAT_HIST_LOG_MASK,
+=09=09.fn=09=3D write_clat_hist_log,
+=09}
 };
=20
 void td_writeout_logs(struct thread_data *td, bool unit_logs)
diff --git a/iolog.h b/iolog.h
index 0438fa7..011179a 100644
--- a/iolog.h
+++ b/iolog.h
@@ -18,6 +18,11 @@ struct io_stat {
 =09fio_fp64_t S;
 };
=20
+struct io_hist {
+=09uint64_t samples;
+=09unsigned long hist_last;
+};
+
 /*
  * A single data sample
  */
@@ -39,6 +44,7 @@ enum {
 =09IO_LOG_TYPE_SLAT,
 =09IO_LOG_TYPE_BW,
 =09IO_LOG_TYPE_IOPS,
+=09IO_LOG_TYPE_HIST,
 };
=20
 #define DEF_LOG_ENTRIES=09=091024
@@ -103,6 +109,14 @@ struct io_log {
 =09unsigned long avg_msec;
 =09unsigned long avg_last;
=20
+  /*
+   * Windowed latency histograms, for keeping track of when we need to
+   * save a copy of the histogram every approximately hist_msec millisecon=
ds.
+   */
+=09struct io_hist hist_window[DDIR_RWDIR_CNT];
+=09unsigned long hist_msec;
+=09int hist_coarseness;
+
 =09pthread_mutex_t chunk_lock;
 =09unsigned int chunk_seq;
 =09struct flist_head chunk_list;
@@ -218,6 +232,8 @@ extern int iolog_file_inflate(const char *);
 struct log_params {
 =09struct thread_data *td;
 =09unsigned long avg_msec;
+=09unsigned long hist_msec;
+=09int hist_coarseness;
 =09int log_type;
 =09int log_offset;
 =09int log_gz;
diff --git a/options.c b/options.c
index 4c56dbe..56d3e2b 100644
--- a/options.c
+++ b/options.c
@@ -3530,6 +3530,37 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {
 =09=09.group=09=3D FIO_OPT_G_INVALID,
 =09},
 =09{
+=09=09.name=09=3D "log_hist_msec",
+=09=09.lname=09=3D "Log histograms (msec)",
+=09=09.type=09=3D FIO_OPT_INT,
+=09=09.off1=09=3D td_var_offset(log_hist_msec),
+=09=09.help=09=3D "Dump completion latency histograms at frequency of this=
 time value",
+=09=09.def=09=3D "0",
+=09=09.category =3D FIO_OPT_C_LOG,
+=09=09.group=09=3D FIO_OPT_G_INVALID,
+=09},
+=09{
+=09=09.name=09=3D "log_hist_coarseness",
+=09=09.lname=09=3D "Histogram logs coarseness",
+=09=09.type=09=3D FIO_OPT_INT,
+=09=09.off1=09=3D td_var_offset(log_hist_coarseness),
+=09=09.help=09=3D "Integer in range [0,6]. Higher coarseness outputs"
+=09=09=09" fewer histogram bins per sample. The number of bins for"
+=09=09=09" these are [1216, 608, 304, 152, 76, 38, 19] respectively.",
+=09=09.def=09=3D "0",
+=09=09.category =3D FIO_OPT_C_LOG,
+=09=09.group=09=3D FIO_OPT_G_INVALID,
+=09},
+=09{
+=09=09.name=09=3D "write_hist_log",
+=09=09.lname=09=3D "Write latency histogram logs",
+=09=09.type=09=3D FIO_OPT_STR_STORE,
+=09=09.off1=09=3D td_var_offset(hist_log_file),
+=09=09.help=09=3D "Write log of latency histograms during run",
+=09=09.category =3D FIO_OPT_C_LOG,
+=09=09.group=09=3D FIO_OPT_G_INVALID,
+=09},
+=09{
 =09=09.name=09=3D "log_max_value",
 =09=09.lname=09=3D "Log maximum instead of average",
 =09=09.type=09=3D FIO_OPT_BOOL,
diff --git a/server.h b/server.h
index 79c751d..c17c3bb 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
=20
 enum {
-=09FIO_SERVER_VER=09=09=09=3D 54,
+=09FIO_SERVER_VER=09=09=09=3D 55,
=20
 =09FIO_SERVER_MAX_FRAGMENT_PDU=09=3D 1024,
 =09FIO_SERVER_MAX_CMD_MB=09=09=3D 2048,
diff --git a/stat.c b/stat.c
index d6787b7..ef9fe7d 100644
--- a/stat.c
+++ b/stat.c
@@ -1965,6 +1965,7 @@ void regrow_logs(struct thread_data *td)
 {
 =09regrow_log(td->slat_log);
 =09regrow_log(td->clat_log);
+=09regrow_log(td->clat_hist_log);
 =09regrow_log(td->lat_log);
 =09regrow_log(td->bw_log);
 =09regrow_log(td->iops_log);
@@ -2195,7 +2196,9 @@ static void add_clat_percentile_sample(struct thread_=
stat *ts,
 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 =09=09     unsigned long usec, unsigned int bs, uint64_t offset)
 {
+=09unsigned long elapsed, this_window;
 =09struct thread_stat *ts =3D &td->ts;
+=09struct io_log *iolog =3D td->clat_hist_log;
=20
 =09td_io_u_lock(td);
=20
@@ -2207,6 +2210,43 @@ void add_clat_sample(struct thread_data *td, enum fi=
o_ddir ddir,
 =09if (ts->clat_percentiles)
 =09=09add_clat_percentile_sample(ts, usec, ddir);
=20
+=09if (iolog && iolog->hist_msec) {
+=09=09struct io_hist *hw =3D &iolog->hist_window[ddir];
+
+=09=09hw->samples++;
+=09=09elapsed =3D mtime_since_now(&td->epoch);
+=09=09if (!hw->hist_last)
+=09=09=09hw->hist_last =3D elapsed;
+=09=09this_window =3D elapsed - hw->hist_last;
+=09=09
+=09=09if (this_window >=3D iolog->hist_msec) {
+=09=09=09unsigned int *io_u_plat;
+=09=09=09unsigned int *dst;
+
+=09=09=09/*
+=09=09=09 * Make a byte-for-byte copy of the latency histogram
+=09=09=09 * stored in td->ts.io_u_plat[ddir], recording it in a
+=09=09=09 * log sample. Note that the matching call to free() is
+=09=09=09 * located in iolog.c after printing this sample to the
+=09=09=09 * log file.
+=09=09=09 */
+=09=09=09io_u_plat =3D (unsigned int *) td->ts.io_u_plat[ddir];
+=09=09=09dst =3D malloc(FIO_IO_U_PLAT_NR * sizeof(unsigned int));
+=09=09=09memcpy(dst, io_u_plat,
+=09=09=09=09FIO_IO_U_PLAT_NR * sizeof(unsigned int));
+=09=09=09__add_log_sample(iolog, (unsigned long )dst, ddir, bs,
+=09=09=09=09=09=09elapsed, offset);
+
+=09=09=09/*
+=09=09=09 * Update the last time we recorded as being now, minus
+=09=09=09 * any drift in time we encountered before actually
+=09=09=09 * making the record.
+=09=09=09 */
+=09=09=09hw->hist_last =3D elapsed - (this_window - iolog->hist_msec);
+=09=09=09hw->samples =3D 0;
+=09=09}
+=09}
+
 =09td_io_u_unlock(td);
 }
=20
diff --git a/thread_options.h b/thread_options.h
index edf090d..449c66f 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -128,6 +128,8 @@ struct thread_options {
 =09unsigned long long rand_seed;
 =09unsigned int dep_use_os_rand;
 =09unsigned int log_avg_msec;
+=09unsigned int log_hist_msec;
+=09unsigned int log_hist_coarseness;
 =09unsigned int log_max;
 =09unsigned int log_offset;
 =09unsigned int log_gz;
@@ -232,6 +234,7 @@ struct thread_options {
 =09char *bw_log_file;
 =09char *lat_log_file;
 =09char *iops_log_file;
+=09char *hist_log_file;
 =09char *replay_redirect;
=20
 =09/*
@@ -382,6 +385,8 @@ struct thread_options_pack {
 =09uint64_t rand_seed;
 =09uint32_t dep_use_os_rand;
 =09uint32_t log_avg_msec;
+=09uint32_t log_hist_msec;
+=09uint32_t log_hist_coarseness;
 =09uint32_t log_max;
 =09uint32_t log_offset;
 =09uint32_t log_gz;
@@ -486,6 +491,7 @@ struct thread_options_pack {
 =09uint8_t bw_log_file[FIO_TOP_STR_MAX];
 =09uint8_t lat_log_file[FIO_TOP_STR_MAX];
 =09uint8_t iops_log_file[FIO_TOP_STR_MAX];
+=09uint8_t hist_log_file[FIO_TOP_STR_MAX];
 =09uint8_t replay_redirect[FIO_TOP_STR_MAX];
=20
 =09/*
diff --git a/tools/hist/.gitignore b/tools/hist/.gitignore
new file mode 100644
index 0000000..4f875da
--- /dev/null
+++ b/tools/hist/.gitignore
@@ -0,0 +1,3 @@
+*.pyc
+*.ipynb
+.ipynb_checkpoints
diff --git a/tools/hist/fiologparser_hist.py b/tools/hist/fiologparser_hist=
.py
new file mode 100755
index 0000000..ce98d2e
--- /dev/null
+++ b/tools/hist/fiologparser_hist.py
@@ -0,0 +1,486 @@
+#!/usr/bin/env python2.7
+"""=20
+    Utility for converting *_clat_hist* files generated by fio into latenc=
y statistics.
+   =20
+    Example usage:
+   =20
+            $ fiologparser_hist.py *_clat_hist*
+            end-time, samples, min, avg, median, 90%, 95%, 99%, max
+            1000, 15, 192, 1678.107, 1788.859, 1856.076, 1880.040, 1899.20=
8, 1888.000
+            2000, 43, 152, 1642.368, 1714.099, 1816.659, 1845.552, 1888.13=
1, 1888.000
+            4000, 39, 1152, 1546.962, 1545.785, 1627.192, 1640.019, 1691.2=
04, 1744
+            ...
+   =20
+    Notes:
+
+    * end-times are calculated to be uniform increments of the --interval =
value given,
+      regardless of when histogram samples are reported. Of note:
+       =20
+        * Intervals with no samples are omitted. In the example above this=
 means
+          "no statistics from 2 to 3 seconds" and "39 samples influenced t=
he statistics
+          of the interval from 3 to 4 seconds".
+       =20
+        * Intervals with a single sample will have the same value for all =
statistics
+       =20
+    * The number of samples is unweighted, corresponding to the total numb=
er of samples
+      which have any effect whatsoever on the interval.
+
+    * Min statistics are computed using value of the lower boundary of the=
 first bin
+      (in increasing bin order) with non-zero samples in it. Similarly for=
 max,
+      we take the upper boundary of the last bin with non-zero samples in =
it.
+      This is semantically identical to taking the 0th and 100th percentil=
es with a
+      50% bin-width buffer (because percentiles are computed using mid-poi=
nts of
+      the bins). This enforces the following nice properties:
+
+        * min <=3D 50th <=3D 90th <=3D 95th <=3D 99th <=3D max
+
+        * min and max are strict lower and upper bounds on the actual
+          min / max seen by fio (and reported in *_clat.* with averaging t=
urned off).
+
+    * Average statistics use a standard weighted arithmetic mean.
+
+    * Percentile statistics are computed using the weighted percentile met=
hod as
+      described here: https://en.wikipedia.org/wiki/Percentile#Weighted_pe=
rcentile
+      See weights() method for details on how weights are computed for ind=
ividual
+      samples. In process_interval() we further multiply by the height of =
each bin
+      to get weighted histograms.
+   =20
+    * We convert files given on the command line, assumed to be fio histog=
ram files,
+      on-the-fly into their corresponding differenced files i.e. non-cumul=
ative histograms
+      because fio outputs cumulative histograms, but we want histograms co=
rresponding
+      to individual time intervals. An individual histogram file can conta=
in the cumulative
+      histograms for multiple different r/w directions (notably when --rw=
=3Drandrw). This
+      is accounted for by tracking each r/w direction separately. In the s=
tatistics
+      reported we ultimately merge *all* histograms (regardless of r/w dir=
ection).
+
+    * The value of *_GROUP_NR in stat.h (and *_BITS) determines how many l=
atency bins
+      fio outputs when histogramming is enabled. Namely for the current de=
fault of
+      GROUP_NR=3D19, we get 1,216 bins with a maximum latency of approxima=
tely 17
+      seconds. For certain applications this may not be sufficient. With G=
ROUP_NR=3D24
+      we have 1,536 bins, giving us a maximum latency of 541 seconds (~ 9 =
minutes). If
+      you expect your application to experience latencies greater than 17 =
seconds,
+      you will need to recompile fio with a larger GROUP_NR, e.g. with:
+       =20
+            sed -i.bak 's/^#define FIO_IO_U_PLAT_GROUP_NR 19\n/#define FIO=
_IO_U_PLAT_GROUP_NR 24/g' stat.h
+            make fio
+           =20
+      Quick reference table for the max latency corresponding to a samplin=
g of
+      values for GROUP_NR:
+           =20
+            GROUP_NR | # bins | max latency bin value
+            19       | 1216   | 16.9 sec
+            20       | 1280   | 33.8 sec
+            21       | 1344   | 67.6 sec
+            22       | 1408   | 2  min, 15 sec
+            23       | 1472   | 4  min, 32 sec
+            24       | 1536   | 9  min, 4  sec
+            25       | 1600   | 18 min, 8  sec
+            26       | 1664   | 36 min, 16 sec
+     =20
+    * At present this program automatically detects the number of histogra=
m bins in
+      the log files, and adjusts the bin latency values accordingly. In pa=
rticular if
+      you use the --log_hist_coarseness parameter of fio, you get output f=
iles with
+      a number of bins according to the following table (note that the fir=
st
+      row is identical to the table above):
+
+      coarse \ GROUP_NR
+                  19     20    21     22     23     24     25     26
+             -------------------------------------------------------
+            0  [[ 1216,  1280,  1344,  1408,  1472,  1536,  1600,  1664],
+            1   [  608,   640,   672,   704,   736,   768,   800,   832],
+            2   [  304,   320,   336,   352,   368,   384,   400,   416],
+            3   [  152,   160,   168,   176,   184,   192,   200,   208],
+            4   [   76,    80,    84,    88,    92,    96,   100,   104],
+            5   [   38,    40,    42,    44,    46,    48,    50,    52],
+            6   [   19,    20,    21,    22,    23,    24,    25,    26],
+            7   [  N/A,    10,   N/A,    11,   N/A,    12,   N/A,    13],
+            8   [  N/A,     5,   N/A,   N/A,   N/A,     6,   N/A,   N/A]]
+
+      For other values of GROUP_NR and coarseness, this table can be compu=
ted like this:   =20
+       =20
+            bins =3D [1216,1280,1344,1408,1472,1536,1600,1664]
+            max_coarse =3D 8
+            fncn =3D lambda z: list(map(lambda x: z/2**x if z % 2**x =3D=
=3D 0 else nan, range(max_coarse + 1)))
+            np.transpose(list(map(fncn, bins)))
+     =20
+      Also note that you can achieve the same downsampling / log file size=
 reduction
+      by pre-processing (before inputting into this script) with half_bins=
.py.
+
+    * If you have not adjusted GROUP_NR for your (high latency) applicatio=
n, then you
+      will see the percentiles computed by this tool max out at the max la=
tency bin
+      value as in the first table above, and in this plot (where GROUP_NR=
=3D19 and thus we see
+      a max latency of ~16.7 seconds in the red line):
+
+            https://www.cronburg.com/fio/max_latency_bin_value_bug.png
+   =20
+    * Motivation for, design decisions, and the implementation process are
+      described in further detail here:
+
+            https://www.cronburg.com/fio/cloud-latency-problem-measurement=
/
+
+    @author Karl Cronburg <karl.cronburg@gmail.com>
+"""
+import os
+import sys
+import pandas
+import numpy as np
+
+err =3D sys.stderr.write
+
+def weighted_percentile(percs, vs, ws):
+    """ Use linear interpolation to calculate the weighted percentile.
+       =20
+        Value and weight arrays are first sorted by value. The cumulative
+        distribution function (cdf) is then computed, after which np.inter=
p
+        finds the two values closest to our desired weighted percentile(s)
+        and linearly interpolates them.
+       =20
+        percs  :: List of percentiles we want to calculate
+        vs     :: Array of values we are computing the percentile of
+        ws     :: Array of weights for our corresponding values
+        return :: Array of percentiles
+    """
+    idx =3D np.argsort(vs)
+    vs, ws =3D vs[idx], ws[idx] # weights and values sorted by value
+    cdf =3D 100 * (ws.cumsum() - ws / 2.0) / ws.sum()
+    return np.interp(percs, cdf, vs) # linear interpolation
+
+def weights(start_ts, end_ts, start, end):
+    """ Calculate weights based on fraction of sample falling in the
+        given interval [start,end]. Weights computed using vector / array
+        computation instead of for-loops.
+   =20
+        Note that samples with zero time length are effectively ignored
+        (we set their weight to zero).
+
+        start_ts :: Array of start times for a set of samples
+        end_ts   :: Array of end times for a set of samples
+        start    :: int
+        end      :: int
+        return   :: Array of weights
+    """
+    sbounds =3D np.maximum(start_ts, start).astype(float)
+    ebounds =3D np.minimum(end_ts,   end).astype(float)
+    ws =3D (ebounds - sbounds) / (end_ts - start_ts)
+    if np.any(np.isnan(ws)):
+      err("WARNING: zero-length sample(s) detected. Log file corrupt"
+          " / bad time values? Ignoring these samples.\n")
+    ws[np.where(np.isnan(ws))] =3D 0.0;
+    return ws
+
+def weighted_average(vs, ws):
+    return np.sum(vs * ws) / np.sum(ws)
+
+columns =3D ["end-time", "samples", "min", "avg", "median", "90%", "95%", =
"99%", "max"]
+percs   =3D [50, 90, 95, 99]
+
+def fmt_float_list(ctx, num=3D1):
+  """ Return a comma separated list of float formatters to the required nu=
mber
+      of decimal places. For instance:
+
+        fmt_float_list(ctx.decimals=3D4, num=3D3) =3D=3D "%.4f, %.4f, %.4f=
"
+  """
+  return ', '.join(["%%.%df" % ctx.decimals] * num)
+
+# Default values - see beginning of main() for how we detect number column=
s in
+# the input files:
+__HIST_COLUMNS =3D 1216
+__NON_HIST_COLUMNS =3D 3
+__TOTAL_COLUMNS =3D __HIST_COLUMNS + __NON_HIST_COLUMNS
+   =20
+def sequential_diffs(head_row, times, rws, hists):
+    """ Take the difference of sequential (in time) histograms with the sa=
me
+        r/w direction, returning a new array of differenced histograms.  "=
""
+    result =3D np.empty(shape=3D(0, __HIST_COLUMNS))
+    result_times =3D np.empty(shape=3D(1, 0))
+    for i in range(8):
+        idx =3D np.where(rws =3D=3D i)
+        diff =3D np.diff(np.append(head_row[i], hists[idx], axis=3D0), axi=
s=3D0).astype(int)
+        result =3D np.append(diff, result, axis=3D0)
+        result_times =3D np.append(times[idx], result_times)
+    idx =3D np.argsort(result_times)
+    return result[idx]
+
+def read_chunk(head_row, rdr, sz):
+    """ Read the next chunk of size sz from the given reader, computing th=
e
+        differences across neighboring histogram samples.
+    """
+    try:
+        """ StopIteration occurs when the pandas reader is empty, and Attr=
ibuteError
+            occurs if rdr is None due to the file being empty. """
+        new_arr =3D rdr.read().values
+    except (StopIteration, AttributeError):
+        return None   =20
+
+    """ Extract array of just the times, and histograms matrix without tim=
es column.
+        Then, take the sequential difference of each of the rows in the hi=
stogram
+        matrix. This is necessary because fio outputs *cumulative* histogr=
ams as
+        opposed to histograms with counts just for a particular interval. =
"""
+    times, rws, szs =3D new_arr[:,0], new_arr[:,1], new_arr[:,2]
+    hists =3D new_arr[:,__NON_HIST_COLUMNS:]
+    hists_diff   =3D sequential_diffs(head_row, times, rws, hists)
+    times =3D times.reshape((len(times),1))
+    arr =3D np.append(times, hists_diff, axis=3D1)
+
+    """ hists[-1] will be the row we need to start our differencing with t=
he
+        next time we call read_chunk() on the same rdr """
+    return arr, hists[-1]
+
+def get_min(fps, arrs):
+    """ Find the file with the current first row with the smallest start t=
ime """
+    return min([fp for fp in fps if not arrs[fp] is None], key=3Dlambda fp=
: arrs.get(fp)[0][0][0])
+
+def histogram_generator(ctx, fps, sz):
+   =20
+    """ head_row for a particular file keeps track of the last (cumulative=
)
+        histogram we read so that we have a reference point to subtract of=
f
+        when computing sequential differences. """
+    head_row  =3D np.zeros(shape=3D(1, __HIST_COLUMNS))
+    head_rows =3D {fp: {i: head_row for i in range(8)} for fp in fps}
+
+    # Create a chunked pandas reader for each of the files:
+    rdrs =3D {}
+    for fp in fps:
+        try:
+            rdrs[fp] =3D pandas.read_csv(fp, dtype=3Dint, header=3DNone, c=
hunksize=3Dsz)
+        except ValueError as e:
+            if e.message =3D=3D 'No columns to parse from file':
+                if not ctx.nowarn: sys.stderr.write("WARNING: Empty input =
file encountered.\n")
+                rdrs[fp] =3D None
+            else:
+                raise(e)
+
+    # Initial histograms and corresponding head_rows:
+    arrs =3D {fp: read_chunk(head_rows[fp], rdr, sz) for fp,rdr in rdrs.it=
ems()}
+    while True:
+
+        try:
+            """ ValueError occurs when nothing more to read """
+            fp =3D get_min(fps, arrs)
+        except ValueError:
+            return
+        arr, head_row =3D arrs[fp]
+        yield np.insert(arr[0], 1, fps.index(fp))
+        arrs[fp] =3D arr[1:], head_row
+        head_rows[fp] =3D head_row
+
+        if arrs[fp][0].shape[0] =3D=3D 0:
+            arrs[fp] =3D read_chunk(head_rows[fp], rdrs[fp], sz)
+
+def _plat_idx_to_val(idx, edge=3D0.5, FIO_IO_U_PLAT_BITS=3D6, FIO_IO_U_PLA=
T_VAL=3D64):
+    """ Taken from fio's stat.c for calculating the latency value of a bin
+        from that bin's index.
+       =20
+            idx  : the value of the index into the histogram bins
+            edge : fractional value in the range [0,1]** indicating how fa=
r into
+            the bin we wish to compute the latency value of.
+       =20
+        ** edge =3D 0.0 and 1.0 computes the lower and upper latency bound=
s
+           respectively of the given bin index. """
+
+    # MSB <=3D (FIO_IO_U_PLAT_BITS-1), cannot be rounded off. Use
+    # all bits of the sample as index
+    if (idx < (FIO_IO_U_PLAT_VAL << 1)):
+        return idx=20
+
+    # Find the group and compute the minimum value of that group
+    error_bits =3D (idx >> FIO_IO_U_PLAT_BITS) - 1=20
+    base =3D 1 << (error_bits + FIO_IO_U_PLAT_BITS)
+
+    # Find its bucket number of the group
+    k =3D idx % FIO_IO_U_PLAT_VAL
+
+    # Return the mean (if edge=3D0.5) of the range of the bucket
+    return base + ((k + edge) * (1 << error_bits))
+   =20
+def plat_idx_to_val_coarse(idx, coarseness, edge=3D0.5):
+    """ Converts the given *coarse* index into a non-coarse index as used =
by fio
+        in stat.h:plat_idx_to_val(), subsequently computing the appropriat=
e
+        latency value for that bin.
+        """
+
+    # Multiply the index by the power of 2 coarseness to get the bin
+    # bin index with a max of 1536 bins (FIO_IO_U_PLAT_GROUP_NR =3D 24 in =
stat.h)
+    stride =3D 1 << coarseness
+    idx =3D idx * stride
+    lower =3D _plat_idx_to_val(idx, edge=3D0.0)
+    upper =3D _plat_idx_to_val(idx + stride, edge=3D1.0)
+    return lower + (upper - lower) * edge
+
+def print_all_stats(ctx, end, mn, ss_cnt, vs, ws, mx):
+    ps =3D weighted_percentile(percs, vs, ws)
+
+    avg =3D weighted_average(vs, ws)
+    values =3D [mn, avg] + list(ps) + [mx]
+    row =3D [end, ss_cnt] + map(lambda x: float(x) / ctx.divisor, values)
+    fmt =3D "%d, %d, %d, " + fmt_float_list(ctx, 5) + ", %d"
+    print (fmt % tuple(row))
+
+def update_extreme(val, fncn, new_val):
+    """ Calculate min / max in the presence of None values """
+    if val is None: return new_val
+    else: return fncn(val, new_val)
+
+# See beginning of main() for how bin_vals are computed
+bin_vals =3D []
+lower_bin_vals =3D [] # lower edge of each bin
+upper_bin_vals =3D [] # upper edge of each bin=20
+
+def process_interval(ctx, samples, iStart, iEnd):
+    """ Construct the weighted histogram for the given interval by scannin=
g
+        through all the histograms and figuring out which of their bins ha=
ve
+        samples with latencies which overlap with the given interval
+        [iStart,iEnd].
+    """
+   =20
+    times, files, hists =3D samples[:,0], samples[:,1], samples[:,2:]
+    iHist =3D np.zeros(__HIST_COLUMNS)
+    ss_cnt =3D 0 # number of samples affecting this interval
+    mn_bin_val, mx_bin_val =3D None, None
+
+    for end_time,file,hist in zip(times,files,hists):
+           =20
+        # Only look at bins of the current histogram sample which
+        # started before the end of the current time interval [start,end]
+        start_times =3D (end_time - 0.5 * ctx.interval) - bin_vals / 1000.=
0
+        idx =3D np.where(start_times < iEnd)
+        s_ts, l_bvs, u_bvs, hs =3D start_times[idx], lower_bin_vals[idx], =
upper_bin_vals[idx], hist[idx]
+
+        # Increment current interval histogram by weighted values of futur=
e histogram:
+        ws =3D hs * weights(s_ts, end_time, iStart, iEnd)
+        iHist[idx] +=3D ws
+   =20
+        # Update total number of samples affecting current interval histog=
ram:
+        ss_cnt +=3D np.sum(hs)
+       =20
+        # Update min and max bin values seen if necessary:
+        idx =3D np.where(hs !=3D 0)[0]
+        if idx.size > 0:
+            mn_bin_val =3D update_extreme(mn_bin_val, min, l_bvs[max(0,   =
        idx[0]  - 1)])
+            mx_bin_val =3D update_extreme(mx_bin_val, max, u_bvs[min(len(h=
s) - 1, idx[-1] + 1)])
+
+    if ss_cnt > 0: print_all_stats(ctx, iEnd, mn_bin_val, ss_cnt, bin_vals=
, iHist, mx_bin_val)
+
+def guess_max_from_bins(ctx, hist_cols):
+    """ Try to guess the GROUP_NR from given # of histogram
+        columns seen in an input file """
+    max_coarse =3D 8
+    if ctx.group_nr < 19 or ctx.group_nr > 26:
+        bins =3D [ctx.group_nr * (1 << 6)]
+    else:
+        bins =3D [1216,1280,1344,1408,1472,1536,1600,1664]
+    coarses =3D range(max_coarse + 1)
+    fncn =3D lambda z: list(map(lambda x: z/2**x if z % 2**x =3D=3D 0 else=
 -10, coarses))
+   =20
+    arr =3D np.transpose(list(map(fncn, bins)))
+    idx =3D np.where(arr =3D=3D hist_cols)
+    if len(idx[1]) =3D=3D 0:
+        table =3D repr(arr.astype(int)).replace('-10', 'N/A').replace('arr=
ay','     ')
+        err("Unable to determine bin values from input clat_hist files. Na=
mely \n"
+            "the first line of file '%s' " % ctx.FILE[0] + "has %d \n" % (=
__TOTAL_COLUMNS,) +
+            "columns of which we assume %d " % (hist_cols,) + "correspond =
to histogram bins. \n"
+            "This number needs to be equal to one of the following numbers=
:\n\n"
+            + table + "\n\n"
+            "Possible reasons and corresponding solutions:\n"
+            "  - Input file(s) does not contain histograms.\n"
+            "  - You recompiled fio with a different GROUP_NR. If so pleas=
e specify this\n"
+            "    new GROUP_NR on the command line with --group_nr\n")
+        exit(1)
+    return bins[idx[1][0]]
+
+def main(ctx):
+
+    # Automatically detect how many columns are in the input files,
+    # calculate the corresponding 'coarseness' parameter used to generate
+    # those files, and calculate the appropriate bin latency values:
+    with open(ctx.FILE[0], 'r') as fp:
+        global bin_vals,lower_bin_vals,upper_bin_vals,__HIST_COLUMNS,__TOT=
AL_COLUMNS
+        __TOTAL_COLUMNS =3D len(fp.readline().split(','))
+        __HIST_COLUMNS =3D __TOTAL_COLUMNS - __NON_HIST_COLUMNS
+
+        max_cols =3D guess_max_from_bins(ctx, __HIST_COLUMNS)
+        coarseness =3D int(np.log2(float(max_cols) / __HIST_COLUMNS))
+        bin_vals =3D np.array(map(lambda x: plat_idx_to_val_coarse(x, coar=
seness), np.arange(__HIST_COLUMNS)), dtype=3Dfloat)
+        lower_bin_vals =3D np.array(map(lambda x: plat_idx_to_val_coarse(x=
, coarseness, 0.0), np.arange(__HIST_COLUMNS)), dtype=3Dfloat)
+        upper_bin_vals =3D np.array(map(lambda x: plat_idx_to_val_coarse(x=
, coarseness, 1.0), np.arange(__HIST_COLUMNS)), dtype=3Dfloat)
+
+    fps =3D [open(f, 'r') for f in ctx.FILE]
+    gen =3D histogram_generator(ctx, fps, ctx.buff_size)
+
+    print(', '.join(columns))
+
+    try:
+        start, end =3D 0, ctx.interval
+        arr =3D np.empty(shape=3D(0,__TOTAL_COLUMNS - 1))
+        more_data =3D True
+        while more_data or len(arr) > 0:
+           =20
+            # Read up to ctx.max_latency (default 20 seconds) of data from=
 end of current interval.
+            while len(arr) =3D=3D 0 or arr[-1][0] < ctx.max_latency * 1000=
 + end:
+                try:
+                    new_arr =3D next(gen)
+                except StopIteration:
+                    more_data =3D False
+                    break
+                arr =3D np.append(arr, new_arr.reshape((1,__TOTAL_COLUMNS =
- 1)), axis=3D0)
+            arr =3D arr.astype(int)
+           =20
+            if arr.size > 0:
+                process_interval(ctx, arr, start, end)
+               =20
+                # Update arr to throw away samples we no longer need - sam=
ples which
+                # end before the start of the next interval, i.e. the end =
of the
+                # current interval:
+                idx =3D np.where(arr[:,0] > end)
+                arr =3D arr[idx]
+           =20
+            start +=3D ctx.interval
+            end =3D start + ctx.interval
+    finally:
+        map(lambda f: f.close(), fps)
+
+
+if __name__ =3D=3D '__main__':
+    import argparse
+    p =3D argparse.ArgumentParser()
+    arg =3D p.add_argument
+    arg("FILE", help=3D'space separated list of latency log filenames', na=
rgs=3D'+')
+    arg('--buff_size',
+        default=3D10000,
+        type=3Dint,
+        help=3D'number of samples to buffer into numpy at a time')
+
+    arg('--max_latency',
+        default=3D20,
+        type=3Dfloat,
+        help=3D'number of seconds of data to process at a time')
+
+    arg('-i', '--interval',
+        default=3D1000,
+        type=3Dint,
+        help=3D'interval width (ms)')
+
+    arg('-d', '--divisor',
+        required=3DFalse,
+        type=3Dint,
+        default=3D1,
+        help=3D'divide the results by this value.')
+
+    arg('--decimals',
+        default=3D3,
+        type=3Dint,
+        help=3D'number of decimal places to print floats to')
+
+    arg('--nowarn',
+        dest=3D'nowarn',
+        action=3D'store_false',
+        default=3DTrue,
+        help=3D'do not print any warning messages to stderr')
+
+    arg('--group_nr',
+        default=3D19,
+        type=3Dint,
+        help=3D'FIO_IO_U_PLAT_GROUP_NR as defined in stat.h')
+
+    main(p.parse_args())
+
diff --git a/tools/hist/half-bins.py b/tools/hist/half-bins.py
new file mode 100755
index 0000000..d592af0
--- /dev/null
+++ b/tools/hist/half-bins.py
@@ -0,0 +1,38 @@
+#!/usr/bin/env python2.7
+""" Cut the number bins in half in fio histogram output. Example usage:
+
+        $ half-bins.py -c 2 output_clat_hist.1.log > smaller_clat_hist.1.l=
og
+
+    Which merges e.g. bins [0 .. 3], [4 .. 7], ..., [1212 .. 1215] resulti=
ng in
+    304 =3D 1216 / (2**2) merged bins per histogram sample.
+
+    @author Karl Cronburg <karl.cronburg@gmail.com>
+"""
+import sys
+
+def main(ctx):
+    stride =3D 1 << ctx.coarseness
+    with open(ctx.FILENAME, 'r') as fp:
+        for line in fp.readlines():
+            vals =3D line.split(', ')
+            sys.stdout.write("%s, %s, %s, " % tuple(vals[:3]))
+
+            hist =3D list(map(int, vals[3:]))
+            for i in range(0, len(hist) - stride, stride):
+                sys.stdout.write("%d, " % sum(hist[i : i + stride],))
+            sys.stdout.write("%d\n" % sum(hist[len(hist) - stride:]))
+
+if __name__ =3D=3D '__main__':
+    import argparse
+    p =3D argparse.ArgumentParser()
+    arg =3D p.add_argument
+    arg( 'FILENAME', help=3D'clat_hist file for which we will reduce'
+                         ' (by half or more) the number of bins.')
+    arg('-c', '--coarseness',
+       default=3D1,
+       type=3Dint,
+       help=3D'number of times to reduce number of bins by half, '
+            'e.g. coarseness of 4 merges each 2^4 =3D 16 consecutive '
+            'bins.')
+    main(p.parse_args())
+
