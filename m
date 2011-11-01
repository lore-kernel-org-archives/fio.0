Return-Path: <tirea@google.com>
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Tue, 1 Nov 2011 14:16:43 -0600
Subject: An alternative way to handle IO engine options
Message-ID: 
 <CAAUT-yMDPw4x-g=6Ag0UQGHGPgbiqctim1OiP8WuuiYr3-PjqQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This isn't quite ready to be a patch yet, but I wanted to get some
feedback before I put in time polishing it to patch level.

The idea has been bouncing around in my head that some IO engines have
unique parameters.  However, fio has no way to make engine specific
parameters, aside from doing special cases in the options parsing, or
using some option in a convoluted way it wasn't intended for.  For
example, the libaio:userspace_reap option, and the net IO engine
turning the filename into a series of fields you have to know the
correct syntax and order for.

Neither of these options seem ideal to me; the first requires special
casing and limits it to a single option, the second results in
potentially cryptic requirements.

At the same time, though, there is only one place in the config
parsing/management which assumes there is a single config
(options_mem_dupe) - everything else is told what the options are and
treats the data as a mostly opaque block of memory, even though it is
just a single global variable and a fixed config structure.  This
seems like it is just begging to be re-used within the IO engine
framework to parse custom options.  So that is what I have done.  For
now in this code just the libaio userspace_reap option has been
changed, but it would make sense to apply the same treatment to the
net IO engine.

The basic idea is it looks through the config section and makes note
of any unrecognized options, rather than reporting them right away.
Then it loads the requested IO engine and runs through the unknown
options against the IO engine config.  At that point, any unknown
options are reported.

There are a few things not finished yet...
1. Right now it is conf parsing only; command line parsing never sees
the new options (But I have a plan, with the restriction that the IO
engine must be named before its options can be used)
2. Documentation for the userspace_reap option will need to be changed.
3. There's currently no way to handle IO engine options in the [global] sec=
tion.

Do you see any problems with this approach to handling options that
are specific to a single IO engine?


diff --git a/engines/libaio.c b/engines/libaio.c
index ad34d06..850b113 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -24,6 +24,22 @@ struct libaio_data {
        int iocbs_nr;
 };

+struct libaio_options {
+       unsigned int userspace_reap;
+};
+
+static struct fio_option options[] =3D {
+       {
+               .name   =3D "userspace_reap",
+               .type   =3D FIO_OPT_STR_SET,
+               .off1   =3D offsetof(struct libaio_options, userspace_reap)=
,
+               .help   =3D "Use alternative user-space reap implementation=
",
+       },
+       {
+               .name   =3D NULL,
+       },
+};
+
 static int fio_libaio_prep(struct thread_data fio_unused *td, struct
io_u *io_u)
 {
        struct fio_file *f =3D io_u->file;
@@ -103,11 +119,12 @@ static int fio_libaio_getevents(struct
thread_data *td, unsigned int min,
                                unsigned int max, struct timespec *t)
 {
        struct libaio_data *ld =3D td->io_ops->data;
+       struct libaio_options *o =3D td->eo;
        unsigned actual_min =3D td->o.iodepth_batch_complete =3D=3D 0 ? 0 :=
 min;
        int r, events =3D 0;

        do {
-               if (td->o.userspace_libaio_reap =3D=3D 1
+               if (o->userspace_reap =3D=3D 1
                    && actual_min =3D=3D 0
                    && ((struct aio_ring *)(ld->aio_ctx))->magic
                                =3D=3D AIO_RING_MAGIC) {
@@ -262,19 +279,21 @@ static int fio_libaio_init(struct thread_data *td)
 }

 static struct ioengine_ops ioengine =3D {
-       .name           =3D "libaio",
-       .version        =3D FIO_IOOPS_VERSION,
-       .init           =3D fio_libaio_init,
-       .prep           =3D fio_libaio_prep,
-       .queue          =3D fio_libaio_queue,
-       .commit         =3D fio_libaio_commit,
-       .cancel         =3D fio_libaio_cancel,
-       .getevents      =3D fio_libaio_getevents,
-       .event          =3D fio_libaio_event,
-       .cleanup        =3D fio_libaio_cleanup,
-       .open_file      =3D generic_open_file,
-       .close_file     =3D generic_close_file,
-       .get_file_size  =3D generic_get_file_size,
+       .name                   =3D "libaio",
+       .version                =3D FIO_IOOPS_VERSION,
+       .init                   =3D fio_libaio_init,
+       .prep                   =3D fio_libaio_prep,
+       .queue                  =3D fio_libaio_queue,
+       .commit                 =3D fio_libaio_commit,
+       .cancel                 =3D fio_libaio_cancel,
+       .getevents              =3D fio_libaio_getevents,
+       .event                  =3D fio_libaio_event,
+       .cleanup                =3D fio_libaio_cleanup,
+       .open_file              =3D generic_open_file,
+       .close_file             =3D generic_close_file,
+       .get_file_size          =3D generic_get_file_size,
+       .options                =3D &options,
+       .option_struct_size     =3D sizeof(struct libaio_options),
 };

 #else /* FIO_HAVE_LIBAIO */
diff --git a/fio.h b/fio.h
index be684ca..f04b132 100644
--- a/fio.h
+++ b/fio.h
@@ -245,8 +245,6 @@ struct thread_options {
        unsigned int gid;

        unsigned int sync_file_range;
-
-       unsigned int userspace_libaio_reap;
 };

 /*
@@ -254,6 +252,7 @@ struct thread_options {
  */
 struct thread_data {
        struct thread_options o;
+       void *eo;
        char verror[FIO_VERROR_SIZE];
        pthread_t thread;
        int thread_number;
@@ -554,11 +553,11 @@ extern int fio_cmd_option_parse(struct
thread_data *, const char *, char *);
 extern void fio_fill_default_options(struct thread_data *);
 extern int fio_show_option_help(const char *);
 extern void fio_options_dup_and_init(struct option *);
-extern void options_mem_dupe(struct thread_data *);
-extern void options_mem_free(struct thread_data *);
+extern void fio_options_mem_dupe(struct thread_data *);
 extern void td_fill_rand_seeds(struct thread_data *);
 extern void add_job_opts(const char **);
 extern char *num2str(unsigned long, int, int, int);
+extern int ioengine_load(struct thread_data *);

 #define FIO_GETOPT_JOB         0x89988998
 #define FIO_NR_OPTIONS         (FIO_MAX_OPTS + 128)
diff --git a/init.c b/init.c
index ee6c139..ed19f15 100644
--- a/init.c
+++ b/init.c
@@ -300,7 +300,7 @@ static struct thread_data *get_new_job(int global,
struct thread_data *parent)
        td->o.uid =3D td->o.gid =3D -1U;

        dup_files(td, parent);
-       options_mem_dupe(td);
+       fio_options_mem_dupe(td);

        profile_add_hooks(td);

@@ -319,6 +319,13 @@ static void put_job(struct thread_data *td)
                log_info("fio: %s\n", td->verror);

        fio_options_free(td);
+       if (td->io_ops) {
+               /*
+                * Never called init(), so don't call cleanup().
+                */
+               td->io_ops->cleanup =3D NULL;
+               close_ioengine(td);
+       }

        memset(&threads[td->thread_number - 1], 0, sizeof(*td));
        thread_number--;
@@ -665,6 +672,43 @@ static int init_random_state(struct thread_data *td)
 }

 /*
+ * Initializes the ioengine configured for a job, if it has not been done =
so
+ * already.
+ */
+int ioengine_load(struct thread_data *td)
+{
+       const char *engine;
+
+       /*
+        * the def_thread is just for options, it's not a real job
+        */
+       if (td =3D=3D &def_thread)
+               return 0;
+
+       /*
+        * Engine has already been loaded.
+        */
+       if (td->io_ops)
+               return 0;
+
+       engine =3D get_engine_name(td->o.ioengine);
+       td->io_ops =3D load_ioengine(td, engine);
+       if (!td->io_ops) {
+               log_err("fio: failed to load engine %s\n", engine);
+               return 1;
+       }
+
+       if (td->io_ops->option_struct_size && td->io_ops->options) {
+               options_init(td->io_ops->options);
+               td->eo =3D malloc(td->io_ops->option_struct_size);
+               memset(td->eo, 0, td->io_ops->option_struct_size);
+               fill_default_options(td->eo, td->io_ops->options);
+       }
+
+       return 0;
+}
+
+/*
  * Adds a job to the list of things todo. Sanitizes the various options
  * to make sure we don't have conflicts, and initializes various
  * members of td.
@@ -674,7 +718,6 @@ static int add_job(struct thread_data *td, const
char *jobname, int job_add_num)
        const char *ddir_str[] =3D { NULL, "read", "write", "rw", NULL,
                                   "randread", "randwrite", "randrw" };
        unsigned int i;
-       const char *engine;
        char fname[PATH_MAX];
        int numjobs, file_alloced;

@@ -695,12 +738,8 @@ static int add_job(struct thread_data *td, const
char *jobname, int job_add_num)
        if (profile_td_init(td))
                goto err;

-       engine =3D get_engine_name(td->o.ioengine);
-       td->io_ops =3D load_ioengine(td, engine);
-       if (!td->io_ops) {
-               log_err("fio: failed to load engine %s\n", engine);
+       if (ioengine_load(td))
                goto err;
-       }

        if (td->o.use_thread)
                nr_thread++;
diff --git a/ioengine.h b/ioengine.h
index 044c4da..be8c7e0 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -1,7 +1,7 @@
 #ifndef FIO_IOENGINE_H
 #define FIO_IOENGINE_H

-#define FIO_IOOPS_VERSION      12
+#define FIO_IOOPS_VERSION      13

 enum {
        IO_U_F_FREE             =3D 1 << 0,
@@ -121,6 +121,8 @@ struct ioengine_ops {
        int (*open_file)(struct thread_data *, struct fio_file *);
        int (*close_file)(struct thread_data *, struct fio_file *);
        int (*get_file_size)(struct thread_data *, struct fio_file *);
+       int option_struct_size;
+       struct fio_option *options;
        void *data;
        void *dlhandle;
 };
diff --git a/ioengines.c b/ioengines.c
index 7f4e104..ebbb948 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -161,6 +161,12 @@ void close_ioengine(struct thread_data *td)
                td->io_ops->data =3D NULL;
        }

+       if (td->eo && td->io_ops->options) {
+               options_free(td->io_ops->options, td->eo);
+               free(td->eo);
+               td->eo =3D NULL;
+       }
+
        if (td->io_ops->dlhandle)
                dlclose(td->io_ops->dlhandle);

diff --git a/options.c b/options.c
index 84bf5ac..35e5837 100644
--- a/options.c
+++ b/options.c
@@ -226,21 +226,6 @@ static int str_rw_cb(void *data, const char *str)
        return 0;
 }

-#ifdef FIO_HAVE_LIBAIO
-static int str_libaio_cb(void *data, const char *str)
-{
-       struct thread_data *td =3D data;
-
-       if (!strcmp(str, "userspace_reap")) {
-               td->o.userspace_libaio_reap =3D 1;
-               return 0;
-       }
-
-       log_err("fio: bad libaio sub-option: %s\n", str);
-       return 1;
-}
-#endif
-
 static int str_mem_cb(void *data, const char *mem)
 {
        struct thread_data *td =3D data;
@@ -999,7 +984,6 @@ static struct fio_option options[FIO_MAX_OPTS] =3D {
 #ifdef FIO_HAVE_LIBAIO
                          { .ival =3D "libaio",
                            .help =3D "Linux native asynchronous IO",
-                           .cb   =3D str_libaio_cb,
                          },
 #endif
 #ifdef FIO_HAVE_POSIXAIO
@@ -1015,7 +999,7 @@ static struct fio_option options[FIO_MAX_OPTS] =3D {
 #ifdef FIO_HAVE_WINDOWSAIO
                          { .ival =3D "windowsaio",
                            .help =3D "Windows native asynchronous IO"
-                         },
+                         },
 #endif
                          { .ival =3D "mmap",
                            .help =3D "Memory mapped IO"
@@ -2389,18 +2373,50 @@ static char **dup_and_sub_options(char **opts,
int num_opts)

 int fio_options_parse(struct thread_data *td, char **opts, int num_opts)
 {
-       int i, ret;
+       int i, ret, engine_loaded;
        char **opts_copy;

        sort_options(opts, options, num_opts);
        opts_copy =3D dup_and_sub_options(opts, num_opts);

        for (ret =3D 0, i =3D 0; i < num_opts; i++) {
-               ret |=3D parse_option(opts_copy[i], opts[i], options, td);
+               struct fio_option *o;
+               int newret =3D parse_option(opts_copy[i], opts[i], options,=
 &o,
+                                         td);
+
+               if (opts_copy[i]) {
+                       if (newret && !o)
+                               continue;
+                       free(opts_copy[i]);
+                       opts_copy[i] =3D NULL;
+               }
+
+               ret |=3D newret;
+       }
+
+       for (i =3D 0, engine_loaded =3D 0; i < num_opts; i++) {
+               struct fio_option *o =3D NULL;
+               int newret =3D 1;
+               if (!opts_copy[i])
+                       continue;
+
+               if (!engine_loaded) {
+                       ioengine_load(td);
+                       engine_loaded =3D 1;
+               }
+
+               if (td->eo)
+                       newret =3D parse_option(opts_copy[i], opts[i],
+                                             td->io_ops->options, &o, td->=
eo);
+
+               ret |=3D newret;
+               if (!o)
+                       log_err("Bad option <%s>\n", opts[i]);

-               if (opts_copy[i])
+               if (opts_copy[i]) {
                        free(opts_copy[i]);
-               opts_copy[i] =3D NULL;
+                       opts_copy[i] =3D NULL;
+               }
        }

        free(opts_copy);
@@ -2422,28 +2438,35 @@ int fio_show_option_help(const char *opt)
        return show_cmd_help(options, opt);
 }

-/*
- * dupe FIO_OPT_STR_STORE options
- */
-void options_mem_dupe(struct thread_data *td)
+static void options_mem_dupe(void *data, struct fio_option *options)
 {
-       struct thread_options *o =3D &td->o;
-       struct fio_option *opt;
+       struct fio_option *o;
        char **ptr;
-       int i;

-       for (i =3D 0, opt =3D &options[0]; opt->name; i++, opt =3D &options=
[i]) {
-               if (opt->type !=3D FIO_OPT_STR_STORE)
+       for (o =3D &options[0]; o->name; o++) {
+               if (o->type !=3D FIO_OPT_STR_STORE)
                        continue;

-               ptr =3D (void *) o + opt->off1;
-               if (!*ptr)
-                       ptr =3D td_var(o, opt->off1);
+               ptr =3D td_var(data, o->off1);
                if (*ptr)
                        *ptr =3D strdup(*ptr);
        }
 }

+/*
+ * dupe FIO_OPT_STR_STORE options
+ */
+void fio_options_mem_dupe(struct thread_data *td)
+{
+       options_mem_dupe(&td->o, options);
+       if (td->eo) {
+               void *oldeo =3D td->eo;
+               td->eo =3D malloc(td->io_ops->option_struct_size);
+               memcpy(td->eo, oldeo, td->io_ops->option_struct_size);
+               options_mem_dupe(td->eo, td->io_ops->options);
+       }
+}
+
 unsigned int fio_get_kb_base(void *data)
 {
        struct thread_data *td =3D data;
@@ -2528,4 +2551,9 @@ void del_opt_posval(const char *optname, const char *=
ival)
 void fio_options_free(struct thread_data *td)
 {
        options_free(options, td);
+       if (td->eo && td->io_ops && td->io_ops->options) {
+               options_free(td->io_ops->options, td->eo);
+               free(td->eo);
+               td->eo =3D NULL;
+       }
 }
diff --git a/parse.c b/parse.c
index 7f7851c..3d846b6 100644
--- a/parse.c
+++ b/parse.c
@@ -799,23 +799,22 @@ int parse_cmd_option(const char *opt, const char *val=
,
 }

 int parse_option(const char *opt, const char *input,
-                struct fio_option *options, void *data)
+                struct fio_option *options, struct fio_option **o, void *d=
ata)
 {
-       struct fio_option *o;
        char *post;

        if (!opt) {
                log_err("fio: failed parsing %s\n", input);
+               *o =3D NULL;
                return 1;
        }

-       o =3D get_option(opt, options, &post);
-       if (!o) {
-               log_err("Bad option <%s>\n", input);
+       *o =3D get_option(opt, options, &post);
+       if (!*o) {
                return 1;
        }

-       if (!handle_option(o, post, data)) {
+       if (!handle_option(*o, post, data)) {
                return 0;
        }

diff --git a/parse.h b/parse.h
index 091923e..ac16c8c 100644
--- a/parse.h
+++ b/parse.h
@@ -65,7 +65,7 @@ struct fio_option {

 typedef int (str_cb_fn)(void *, char *);

-extern int parse_option(const char *, const char *, struct fio_option
*, void *);
+extern int parse_option(const char *, const char *, struct fio_option
*, struct fio_option **, void *);
 extern void sort_options(char **, struct fio_option *, int);
 extern int parse_cmd_option(const char *t, const char *l, struct
fio_option *, void *);
 extern int show_cmd_help(struct fio_option *, const char *);

