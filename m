Return-Path: <tirea@google.com>
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Fri, 4 Nov 2011 18:52:46 -0600
Subject: [PATCH] Private parameters for ioengines
Message-ID: 
 <CAAUT-yM_rfE3g34=HRmqt35BKzqFW4B-PSQm1+y50mjzLvO=NA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Here is the polished version of the engine private options patch.  As
discussed, the global section only ever tracks the private options for
the globally defined ioengine.  For command line parameters, the
ioengine must be selected before any private options are used.  (IE
--ioengine=3Dlibaio --userspace_reap will work, but --userspace_reap
--ioengine=3Dlibaio will not.)

The userspace_reap option from libaio has been moved over to this new
option method, usage should be identical to before.
The net ioengine has been modified to use parameters, with hostname,
port, protocol and listen defined as ioengine private parameters.  The
old style of hostname=3Dhost,port,protocol no longer works, so usage
will need to be updated.  (It will spit out an error that should be
clear enough that it changed if this is tried.)  Also, with the new
way for specifying parameters, the net IO engine now allows data to
flow in either direction on TCP connections, regardless of which end
initiates the connection.

There's also a new command line argument --enghelp which can be used
to get help on ioengine private parameters, similar to --cmdhelp.
With no argument, it lists all built-in ioengine.  The argument is an
ioengine name (Or path to .so) and optionally a comma followed by a
command name, which behaves identically to --cmdhelp.

For ioengine authorship, if options are supplied, both the options
structure and the size of the storage needed must be supplied, and the
storage must be large enough to hold a pointer to struct thread_data;
that is because the options callback doesn't explicitly have a pointer
to the thread data (Normally it relies on the fact that the options
struct is the start of the thread data), so the offset 0 of the struct
must point to the thread data, and is filled in automatically.  (This
also neatly provides a guarantee that offset 0 is reserved in the
options data, so it can be safely used as a test of undefined.)

diff --git a/HOWTO b/HOWTO
index 41edcf1..2403a5c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -524,16 +524,7 @@ ioengine=3Dstr       Defines how the job issues io to =
the
file. The following
                        libaio  Linux native asynchronous io. Note that Lin=
ux
                                may only support queued behaviour with
                                non-buffered IO (set direct=3D1 or buffered=
=3D0).
-                               This engine also has a sub-option,
-                               userspace_reap. To set it, use
-                               ioengine=3Dlibaio:userspace_reap. Normally,=
 with
-                               the libaio engine in use, fio will use the
-                               io_getevents system call to reap newly retu=
rned
-                               events. With this flag turned on, the AIO r=
ing
-                               will be read directly from user-space to re=
ap
-                               events. The reaping mode is only enabled wh=
en
-                               polling for a minimum of 0 events (eg when
-                               iodepth_batch_complete=3D0).
+                               This engine defines engine specific options=
.

                        posixaio glibc posix asynchronous io.

@@ -562,16 +553,16 @@ ioengine=3Dstr      Defines how the job issues io to
the file. The following
                                itself and for debugging/testing purposes.

                        net     Transfer over the network to given host:por=
t.
-                               'filename' must be set appropriately to
-                               filename=3Dhost/port/protocol regardless of=
 send
-                               or receive, if the latter only the port
-                               argument is used. 'host' may be an IP addre=
ss
-                               or hostname, port is the port number to be =
used,
-                               and protocol may be 'udp' or 'tcp'. If no
-                               protocol is given, TCP is used.
+                               Depending on the protocol used, the hostnam=
e,
+                               port, listen and filename options are used =
to
+                               specify what sort of connection to make, wh=
ile
+                               the protocol option determines which protoc=
ol
+                               will be used.
+                               This engine defines engine specific options=
.

                        netsplice Like net, but uses splice/vmsplice to
                                map data and send/receive.
+                               This engine defines engine specific options=
.

                        cpuio   Doesn't transfer any data, but burns CPU
                                cycles according to the cpuload=3D and
@@ -1210,6 +1201,45 @@ uid=3Dint          Instead of running as the invokin=
g
user, set the user ID to

 gid=3Dint                Set group ID, see uid.

+In addition, there are some parameters which are only valid when a specifi=
c
+ioengine is in use. These are used identically to normal parameters, with =
the
+caveat that when used on the command line, they must come after the ioengi=
ne
+that defines them is selected.
+
+[libaio] userspace_reap Normally, with the libaio engine in use, fio will =
use
+               the io_getevents system call to reap newly returned events.
+               With this flag turned on, the AIO ring will be read directl=
y
+               from user-space to reap events. The reaping mode is only
+               enabled when polling for a minimum of 0 events (eg when
+               iodepth_batch_complete=3D0).
+
+[netsplice] hostname=3Dstr
+[net] hostname=3Dstr The host name or IP address to use for TCP or UDP bas=
ed IO.
+               If the job is a TCP listener or UDP reader, the hostname is=
 not
+               used and must be omitted.
+
+[netsplice] port=3Dint
+[net] port=3Dint The TCP or UDP port to bind to or connect to.
+
+[netsplice] protocol=3Dstr
+[netsplice] proto=3Dstr
+[net] protocol=3Dstr
+[net] proto=3Dstr        The network protocol to use. Accepted values are:
+
+                       tcp     Transmission control protocol
+                       udp     Unreliable datagram protocol
+                       unix    UNIX domain socket
+
+               When the protocol is TCP or UDP, the port must also be give=
n,
+               as well as the hostname if the job is a TCP listener or UDP
+               reader. For unix sockets, the normal filename option should=
 be
+               used and the port is invalid.
+
+[net] listen   For TCP network connections, tell fio to listen for incomin=
g
+               connections rather than initiating an outgoing connection. =
The
+               hostname must be omitted if this option is used.
+
+
 6.0 Interpreting the output
 ---------------------------

diff --git a/README b/README
index b2fdd0b..03e6751 100644
--- a/README
+++ b/README
@@ -140,6 +140,8 @@ $ fio
        --terse-version=3Dtype    Terse version output format (default 3, o=
r 2).
        --help                  Print this page
        --cmdhelp=3Dcmd           Print command help, "all" for all of them
+       --enghelp=3Dengine        Print ioengine help, or list available io=
engines
+       --enghelp=3Dengine,cmd    Print help for an ioengine cmd
        --showcmd               Turn a job file into command line options
        --readonly              Turn on safety read-only checks, preventing
                                writes
diff --git a/engines/libaio.c b/engines/libaio.c
index ad34d06..e4869aa 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -24,6 +24,23 @@ struct libaio_data {
        int iocbs_nr;
 };

+struct libaio_options {
+       struct thread_data *td;
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
@@ -103,11 +120,12 @@ static int fio_libaio_getevents(struct
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
@@ -262,19 +280,21 @@ static int fio_libaio_init(struct thread_data *td)
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
+       .options                =3D options,
+       .option_struct_size     =3D sizeof(struct libaio_options),
 };

 #else /* FIO_HAVE_LIBAIO */
diff --git a/engines/net.c b/engines/net.c
index d6821a4..ebddb09 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -22,15 +22,19 @@

 struct netio_data {
        int listenfd;
-       int send_to_net;
        int use_splice;
-       int type;
        int pipes[2];
-       char host[64];
        struct sockaddr_in addr;
        struct sockaddr_un addr_un;
 };

+struct netio_options {
+       struct thread_data *td;
+       unsigned int port;
+       unsigned int proto;
+       unsigned int listen;
+};
+
 struct udp_close_msg {
        uint32_t magic;
        uint32_t cmd;
@@ -45,6 +49,55 @@ enum {
        FIO_TYPE_UNIX   =3D 3,
 };

+static int str_hostname_cb(void *data, const char *input);
+static struct fio_option options[] =3D {
+       {
+               .name   =3D "hostname",
+               .type   =3D FIO_OPT_STR_STORE,
+               .cb     =3D str_hostname_cb,
+               .help   =3D "Hostname for net IO engine",
+       },
+       {
+               .name   =3D "port",
+               .type   =3D FIO_OPT_INT,
+               .off1   =3D offsetof(struct netio_options, port),
+               .minval =3D 1,
+               .maxval =3D 65535,
+               .help   =3D "Port to use for TCP or UDP net connections",
+       },
+       {
+               .name   =3D "protocol",
+               .alias  =3D "proto",
+               .type   =3D FIO_OPT_STR,
+               .off1   =3D offsetof(struct netio_options, proto),
+               .help   =3D "Network protocol to use",
+               .def    =3D "tcp",
+               .posval =3D {
+                         { .ival =3D "tcp",
+                           .oval =3D FIO_TYPE_TCP,
+                           .help =3D "Transmission Control Protocol",
+                         },
+                         { .ival =3D "udp",
+                           .oval =3D FIO_TYPE_UDP,
+                           .help =3D "Unreliable Datagram Protocol",
+                         },
+                         { .ival =3D "unix",
+                           .oval =3D FIO_TYPE_UNIX,
+                           .help =3D "UNIX domain socket",
+                         },
+               },
+       },
+       {
+               .name   =3D "listen",
+               .type   =3D FIO_OPT_STR_SET,
+               .off1   =3D offsetof(struct netio_options, listen),
+               .help   =3D "Listen for incoming TCP connections",
+       },
+       {
+               .name   =3D NULL,
+       },
+};
+
 /*
  * Return -1 for error and 'nr events' for a positive number
  * of events
@@ -78,13 +131,16 @@ static int poll_wait(struct thread_data *td, int
fd, short events)

 static int fio_netio_prep(struct thread_data *td, struct io_u *io_u)
 {
-       struct netio_data *nd =3D td->io_ops->data;
+       struct netio_options *o =3D td->eo;

        /*
         * Make sure we don't see spurious reads to a receiver, and vice ve=
rsa
         */
-       if ((nd->send_to_net && io_u->ddir =3D=3D DDIR_READ) ||
-           (!nd->send_to_net && io_u->ddir =3D=3D DDIR_WRITE)) {
+       if (o->proto =3D=3D FIO_TYPE_TCP)
+               return 0;
+
+       if ((o->listen && io_u->ddir =3D=3D DDIR_WRITE) ||
+           (!o->listen && io_u->ddir =3D=3D DDIR_READ)) {
                td_verror(td, EINVAL, "bad direction");
                return 1;
        }
@@ -230,10 +286,11 @@ static int fio_netio_splice_out(struct
thread_data *td, struct io_u *io_u)
 static int fio_netio_send(struct thread_data *td, struct io_u *io_u)
 {
        struct netio_data *nd =3D td->io_ops->data;
+       struct netio_options *o =3D td->eo;
        int ret, flags =3D OS_MSG_DONTWAIT;

        do {
-               if (nd->type =3D=3D FIO_TYPE_UDP) {
+               if (o->proto =3D=3D FIO_TYPE_UDP) {
                        struct sockaddr *to =3D (struct sockaddr *) &nd->ad=
dr;

                        ret =3D sendto(io_u->file->fd, io_u->xfer_buf,
@@ -283,10 +340,11 @@ static int is_udp_close(struct io_u *io_u, int len)
 static int fio_netio_recv(struct thread_data *td, struct io_u *io_u)
 {
        struct netio_data *nd =3D td->io_ops->data;
+       struct netio_options *o =3D td->eo;
        int ret, flags =3D OS_MSG_DONTWAIT;

        do {
-               if (nd->type =3D=3D FIO_TYPE_UDP) {
+               if (o->proto =3D=3D FIO_TYPE_UDP) {
                        fio_socklen_t len =3D sizeof(nd->addr);
                        struct sockaddr *from =3D (struct sockaddr *) &nd->=
addr;

@@ -316,19 +374,20 @@ static int fio_netio_recv(struct thread_data
*td, struct io_u *io_u)
 static int fio_netio_queue(struct thread_data *td, struct io_u *io_u)
 {
        struct netio_data *nd =3D td->io_ops->data;
+       struct netio_options *o =3D td->eo;
        int ret;

        fio_ro_check(td, io_u);

        if (io_u->ddir =3D=3D DDIR_WRITE) {
-               if (!nd->use_splice || nd->type =3D=3D FIO_TYPE_UDP ||
-                   nd->type =3D=3D FIO_TYPE_UNIX)
+               if (!nd->use_splice || o->proto =3D=3D FIO_TYPE_UDP ||
+                   o->proto =3D=3D FIO_TYPE_UNIX)
                        ret =3D fio_netio_send(td, io_u);
                else
                        ret =3D fio_netio_splice_out(td, io_u);
        } else if (io_u->ddir =3D=3D DDIR_READ) {
-               if (!nd->use_splice || nd->type =3D=3D FIO_TYPE_UDP ||
-                   nd->type =3D=3D FIO_TYPE_UDP)
+               if (!nd->use_splice || o->proto =3D=3D FIO_TYPE_UDP ||
+                   o->proto =3D=3D FIO_TYPE_UNIX)
                        ret =3D fio_netio_recv(td, io_u);
                else
                        ret =3D fio_netio_splice_in(td, io_u);
@@ -359,19 +418,20 @@ static int fio_netio_queue(struct thread_data
*td, struct io_u *io_u)
 static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 {
        struct netio_data *nd =3D td->io_ops->data;
+       struct netio_options *o =3D td->eo;
        int type, domain;

-       if (nd->type =3D=3D FIO_TYPE_TCP) {
+       if (o->proto =3D=3D FIO_TYPE_TCP) {
                domain =3D AF_INET;
                type =3D SOCK_STREAM;
-       } else if (nd->type =3D=3D FIO_TYPE_UDP) {
+       } else if (o->proto =3D=3D FIO_TYPE_UDP) {
                domain =3D AF_INET;
                type =3D SOCK_DGRAM;
-       } else if (nd->type =3D=3D FIO_TYPE_UNIX) {
+       } else if (o->proto =3D=3D FIO_TYPE_UNIX) {
                domain =3D AF_UNIX;
                type =3D SOCK_STREAM;
        } else {
-               log_err("fio: bad network type %d\n", nd->type);
+               log_err("fio: bad network type %d\n", o->proto);
                f->fd =3D -1;
                return 1;
        }
@@ -382,9 +442,9 @@ static int fio_netio_connect(struct thread_data
*td, struct fio_file *f)
                return 1;
        }

-       if (nd->type =3D=3D FIO_TYPE_UDP)
+       if (o->proto =3D=3D FIO_TYPE_UDP)
                return 0;
-       else if (nd->type =3D=3D FIO_TYPE_TCP) {
+       else if (o->proto =3D=3D FIO_TYPE_TCP) {
                fio_socklen_t len =3D sizeof(nd->addr);

                if (connect(f->fd, (struct sockaddr *) &nd->addr, len) < 0)=
 {
@@ -411,9 +471,10 @@ static int fio_netio_connect(struct thread_data
*td, struct fio_file *f)
 static int fio_netio_accept(struct thread_data *td, struct fio_file *f)
 {
        struct netio_data *nd =3D td->io_ops->data;
+       struct netio_options *o =3D td->eo;
        fio_socklen_t socklen =3D sizeof(nd->addr);

-       if (nd->type =3D=3D FIO_TYPE_UDP) {
+       if (o->proto =3D=3D FIO_TYPE_UDP) {
                f->fd =3D nd->listenfd;
                return 0;
        }
@@ -464,13 +525,13 @@ static void fio_netio_udp_close(struct
thread_data *td, struct fio_file *f)

 static int fio_netio_close_file(struct thread_data *td, struct fio_file *f=
)
 {
-       struct netio_data *nd =3D td->io_ops->data;
+       struct netio_options *o =3D td->eo;

        /*
         * If this is an UDP connection, notify the receiver that we are
         * closing down the link
         */
-       if (nd->type =3D=3D FIO_TYPE_UDP)
+       if (o->proto =3D=3D FIO_TYPE_UDP)
                fio_netio_udp_close(td, f);

        return generic_close_file(td, f);
@@ -510,15 +571,15 @@ static int fio_netio_setup_connect_unix(struct
thread_data *td,
        return 0;
 }

-static int fio_netio_setup_connect(struct thread_data *td, const char *hos=
t,
-                                  unsigned short port)
+static int fio_netio_setup_connect(struct thread_data *td)
 {
-       struct netio_data *nd =3D td->io_ops->data;
+       struct netio_options *o =3D td->eo;

-       if (nd->type =3D=3D FIO_TYPE_UDP || nd->type =3D=3D FIO_TYPE_TCP)
-               return fio_netio_setup_connect_inet(td, host, port);
+       if (o->proto =3D=3D FIO_TYPE_UDP || o->proto =3D=3D FIO_TYPE_TCP)
+               return fio_netio_setup_connect_inet(td, td->o.filename,
+                                                   o->port);
        else
-               return fio_netio_setup_connect_unix(td, host);
+               return fio_netio_setup_connect_unix(td, td->o.filename);
 }

 static int fio_netio_setup_listen_unix(struct thread_data *td, const
char *path)
@@ -557,9 +618,10 @@ static int fio_netio_setup_listen_unix(struct
thread_data *td, const char *path)
 static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 {
        struct netio_data *nd =3D td->io_ops->data;
+       struct netio_options *o =3D td->eo;
        int fd, opt, type;

-       if (nd->type =3D=3D FIO_TYPE_TCP)
+       if (o->proto =3D=3D FIO_TYPE_TCP)
                type =3D SOCK_STREAM;
        else
                type =3D SOCK_DGRAM;
@@ -595,20 +657,20 @@ static int fio_netio_setup_listen_inet(struct
thread_data *td, short port)
        return 0;
 }

-static int fio_netio_setup_listen(struct thread_data *td, const char *path=
,
-                                 short port)
+static int fio_netio_setup_listen(struct thread_data *td)
 {
        struct netio_data *nd =3D td->io_ops->data;
+       struct netio_options *o =3D td->eo;
        int ret;

-       if (nd->type =3D=3D FIO_TYPE_UDP || nd->type =3D=3D FIO_TYPE_TCP)
-               ret =3D fio_netio_setup_listen_inet(td, port);
+       if (o->proto =3D=3D FIO_TYPE_UDP || o->proto =3D=3D FIO_TYPE_TCP)
+               ret =3D fio_netio_setup_listen_inet(td, o->port);
        else
-               ret =3D fio_netio_setup_listen_unix(td, path);
+               ret =3D fio_netio_setup_listen_unix(td, td->o.filename);

        if (ret)
                return ret;
-       if (nd->type =3D=3D FIO_TYPE_UDP)
+       if (o->proto =3D=3D FIO_TYPE_UDP)
                return 0;

        if (listen(nd->listenfd, 10) < 0) {
@@ -622,72 +684,46 @@ static int fio_netio_setup_listen(struct
thread_data *td, const char *path,

 static int fio_netio_init(struct thread_data *td)
 {
-       struct netio_data *nd =3D td->io_ops->data;
-       unsigned int port;
-       char host[64], buf[128];
-       char *sep, *portp, *modep;
+       struct netio_options *o =3D td->eo;
        int ret;

-       if (td_rw(td)) {
-               log_err("fio: network connections must be read OR write\n")=
;
-               return 1;
-       }
        if (td_random(td)) {
                log_err("fio: network IO can't be random\n");
                return 1;
        }

-       strcpy(buf, td->o.filename);
-
-       sep =3D strchr(buf, ',');
-       if (!sep)
-               goto bad_host;
+       if (o->proto =3D=3D FIO_TYPE_UNIX && o->port) {
+               log_err("fio: network IO port not valid with unix socket\n"=
);
+               return 1;
+       } else if (o->proto !=3D FIO_TYPE_UNIX && !o->port) {
+               log_err("fio: network IO requires port for tcp or udp\n");
+               return 1;
+       }

-       *sep =3D '\0';
-       sep++;
-       strcpy(host, buf);
-       if (!strlen(host))
-               goto bad_host;
+       if (o->proto !=3D FIO_TYPE_TCP) {
+               if (o->listen) {
+                         log_err("fio: listen only valid for TCP proto IO\=
n");
+                         return 1;
+               }
+               if (td_rw(td)) {
+                         log_err("fio: datagram network connections must b=
e"
+                                  " read OR write\n");
+                         return 1;
+               }
+               o->listen =3D td_read(td);
+       }

-       modep =3D NULL;
-       portp =3D sep;
-       sep =3D strchr(portp, ',');
-       if (sep) {
-               *sep =3D '\0';
-               modep =3D sep + 1;
+       if (o->proto !=3D FIO_TYPE_UNIX && o->listen && td->o.filename) {
+               log_err("fio: hostname not valid for inbound network IO\n")=
;
+               return 1;
        }

-       if (!strncmp("tcp", modep, strlen(modep)) ||
-           !strncmp("TCP", modep, strlen(modep)))
-               nd->type =3D FIO_TYPE_TCP;
-       else if (!strncmp("udp", modep, strlen(modep)) ||
-                !strncmp("UDP", modep, strlen(modep)))
-               nd->type =3D FIO_TYPE_UDP;
-       else if (!strncmp("unix", modep, strlen(modep)) ||
-                !strncmp("UNIX", modep, strlen(modep)))
-               nd->type =3D FIO_TYPE_UNIX;
+       if (o->listen)
+               ret =3D fio_netio_setup_listen(td);
        else
-               goto bad_host;
-
-       if (nd->type !=3D FIO_TYPE_UNIX) {
-               port =3D strtol(portp, NULL, 10);
-               if (!port || port > 65535)
-                       goto bad_host;
-       } else
-               port =3D 0;
-
-       if (td_read(td)) {
-               nd->send_to_net =3D 0;
-               ret =3D fio_netio_setup_listen(td, host, port);
-       } else {
-               nd->send_to_net =3D 1;
-               ret =3D fio_netio_setup_connect(td, host, port);
-       }
+               ret =3D fio_netio_setup_connect(td);

        return ret;
-bad_host:
-       log_err("fio: bad network host/port/protocol: %s\n", td->o.filename=
);
-       return 1;
 }

 static void fio_netio_cleanup(struct thread_data *td)
@@ -710,6 +746,11 @@ static int fio_netio_setup(struct thread_data *td)
 {
        struct netio_data *nd;

+       if (!td->files_index) {
+               add_file(td, td->o.filename ?: "net");
+               td->o.nr_files =3D td->o.nr_files ?: 1;
+       }
+
        if (!td->io_ops->data) {
                nd =3D malloc(sizeof(*nd));;

@@ -742,34 +783,48 @@ static int fio_netio_setup_splice(struct thread_data =
*td)
 }

 static struct ioengine_ops ioengine_splice =3D {
-       .name           =3D "netsplice",
-       .version        =3D FIO_IOOPS_VERSION,
-       .prep           =3D fio_netio_prep,
-       .queue          =3D fio_netio_queue,
-       .setup          =3D fio_netio_setup_splice,
-       .init           =3D fio_netio_init,
-       .cleanup        =3D fio_netio_cleanup,
-       .open_file      =3D fio_netio_open_file,
-       .close_file     =3D generic_close_file,
-       .flags          =3D FIO_SYNCIO | FIO_DISKLESSIO | FIO_UNIDIR |
-                         FIO_SIGTERM | FIO_PIPEIO,
+       .name                   =3D "netsplice",
+       .version                =3D FIO_IOOPS_VERSION,
+       .prep                   =3D fio_netio_prep,
+       .queue                  =3D fio_netio_queue,
+       .setup                  =3D fio_netio_setup_splice,
+       .init                   =3D fio_netio_init,
+       .cleanup                =3D fio_netio_cleanup,
+       .open_file              =3D fio_netio_open_file,
+       .close_file             =3D generic_close_file,
+       .options                =3D options,
+       .option_struct_size     =3D sizeof(struct netio_options),
+       .flags                  =3D FIO_SYNCIO | FIO_DISKLESSIO | FIO_UNIDI=
R |
+                                 FIO_SIGTERM | FIO_PIPEIO,
 };
 #endif

 static struct ioengine_ops ioengine_rw =3D {
-       .name           =3D "net",
-       .version        =3D FIO_IOOPS_VERSION,
-       .prep           =3D fio_netio_prep,
-       .queue          =3D fio_netio_queue,
-       .setup          =3D fio_netio_setup,
-       .init           =3D fio_netio_init,
-       .cleanup        =3D fio_netio_cleanup,
-       .open_file      =3D fio_netio_open_file,
-       .close_file     =3D fio_netio_close_file,
-       .flags          =3D FIO_SYNCIO | FIO_DISKLESSIO | FIO_UNIDIR |
-                         FIO_SIGTERM | FIO_PIPEIO,
+       .name                   =3D "net",
+       .version                =3D FIO_IOOPS_VERSION,
+       .prep                   =3D fio_netio_prep,
+       .queue                  =3D fio_netio_queue,
+       .setup                  =3D fio_netio_setup,
+       .init                   =3D fio_netio_init,
+       .cleanup                =3D fio_netio_cleanup,
+       .open_file              =3D fio_netio_open_file,
+       .close_file             =3D fio_netio_close_file,
+       .options                =3D options,
+       .option_struct_size     =3D sizeof(struct netio_options),
+       .flags                  =3D FIO_SYNCIO | FIO_DISKLESSIO | FIO_UNIDI=
R |
+                                 FIO_SIGTERM | FIO_PIPEIO,
 };

+static int str_hostname_cb(void *data, const char *input)
+{
+       struct netio_options *o =3D data;
+
+       if (o->td->o.filename)
+               free(o->td->o.filename);
+       o->td->o.filename =3D strdup(input);
+       return 0;
+}
+
 static void fio_init fio_netio_register(void)
 {
        register_ioengine(&ioengine_rw);
diff --git a/fio.1 b/fio.1
index aae7657..138208f 100644
--- a/fio.1
+++ b/fio.1
@@ -44,6 +44,9 @@ Display usage information and exit.
 .BI \-\-cmdhelp \fR=3D\fPcommand
 Print help information for \fIcommand\fR.  May be `all' for all commands.
 .TP
+.BI \-\-enghelp \fR=3D\fPioengine[,command]
+List all commands defined by \fIioengine\fR, or print help for
\fIcommand\fR defined by \fIioengine\fR.
+.TP
 .BI \-\-showcmd \fR=3D\fPjobfile
 Convert \fIjobfile\fR to a set of command-line options.
 .TP
@@ -142,9 +145,8 @@ than `./'.
 .B fio
 normally makes up a file name based on the job name, thread number, and fi=
le
 number. If you want to share files between threads in a job or several job=
s,
-specify a \fIfilename\fR for each of them to override the default. If the =
I/O
-engine used is `net', \fIfilename\fR is the host and port to connect to in=
 the
-format \fIhost\fR/\fIport\fR. If the I/O engine is file-based, you can spe=
cify
+specify a \fIfilename\fR for each of them to override the default.
+If the I/O engine is file-based, you can specify
 a number of files by separating the names with a `:' character. `\-' is a
 reserved name, meaning stdin or stdout, depending on the read/write direct=
ion
 set.
@@ -398,13 +400,7 @@ Basic \fIreadv\fR\|(2) or \fIwritev\fR\|(2) I/O.
Will emulate queuing by
 coalescing adjacents IOs into a single submission.
 .TP
 .B libaio
-Linux native asynchronous I/O.  This engine also has a sub-option,
-\fBuserspace_reap\fR. To set it, use \fBioengine=3Dlibaio:userspace_reap\f=
R.
-Normally, with the libaio engine in use, fio will use the
-\fIio_getevents\fR\|(3) system call to reap newly returned events. With th=
is
-flag turned on, the AIO ring will be read directly from user-space to reap
-events. The reaping mode is only enabled when polling for a minimum of \fB=
0\fR
-events (eg when \fBiodepth_batch_complete=3D0\fR).
+Linux native asynchronous I/O. This ioengine defines engine specific optio=
ns.
 .TP
 .B posixaio
 POSIX asynchronous I/O using \fIaio_read\fR\|(3) and \fIaio_write\fR\|(3).
@@ -436,14 +432,14 @@ Doesn't transfer any data, just pretends to.
Mainly used to exercise \fBfio\fR
 itself and for debugging and testing purposes.
 .TP
 .B net
-Transfer over the network.  \fBfilename\fR must be set appropriately to
-`\fIhost\fR,\fIport\fR,\fItype\fR' regardless of data direction. \fItype\f=
R
-is one of \fBtcp\fR, \fBudp\fR, or \fBunix\fR. For UNIX domain sockets,
-the \fIhost\fR parameter is a file system path.
+Transfer over the network.  The protocol to be used can be defined with th=
e
+\fBprotocol\fR parameter.  Depending on the protocol, \fBfilename\fR,
+\fBhostname\fR, \fBport\fR, or \fBlisten\fR must be specified.
+This ioengine defines engine specific options.
 .TP
 .B netsplice
 Like \fBnet\fR, but uses \fIsplice\fR\|(2) and \fIvmsplice\fR\|(2) to map =
data
-and send/receive.
+and send/receive. This ioengine defines engine specific options.
 .TP
 .B cpuio
 Doesn't transfer any data, but burns CPU cycles according to \fBcpuload\fR=
 and
@@ -965,6 +961,52 @@ the maximum length of the list is 20. Use ':' to
separate the
 numbers. For example, \-\-percentile_list=3D99.5:99.9 will cause fio to
 report the values of completion latency below which 99.5% and 99.9% of
 the observed latencies fell, respectively.
+.SS "Ioengine Parameters List"
+Some parameters are only valid when a specific ioengine is in use. These a=
re
+used identically to normal parameters, with the caveat that when used on t=
he
+command line, the must come after the ioengine that defines them is select=
ed.
+.TP
+.BI (libaio)userspace_reap
+Normally, with the libaio engine in use, fio will use
+the io_getevents system call to reap newly returned events.
+With this flag turned on, the AIO ring will be read directly
+from user-space to reap events. The reaping mode is only
+enabled when polling for a minimum of 0 events (eg when
+iodepth_batch_complete=3D0).
+.TP
+.BI (net,netsplice)hostname \fR=3D\fPstr
+The host name or IP address to use for TCP or UDP based IO.
+If the job is a TCP listener or UDP reader, the hostname is not
+used and must be omitted.
+.TP
+.BI (net,netsplice)port \fR=3D\fPint
+The TCP or UDP port to bind to or connect to.
+.TP
+.BI (net,netsplice)protocol \fR=3D\fPstr "\fR,\fP proto" \fR=3D\fPstr
+The network protocol to use. Accepted values are:
+.RS
+.RS
+.TP
+.B tcp
+Transmission control protocol
+.TP
+.B udp
+Unreliable datagram protocol
+.TP
+.B unix
+UNIX domain socket
+.RE
+.P
+When the protocol is TCP or UDP, the port must also be given,
+as well as the hostname if the job is a TCP listener or UDP
+reader. For unix sockets, the normal filename option should be
+used and the port is invalid.
+.RE
+.TP
+.BI (net,netsplice)listen
+For TCP network connections, tell fio to listen for incoming
+connections rather than initiating an outgoing connection. The
+hostname must be omitted if this option is used.
 .SH OUTPUT
 While running, \fBfio\fR will display the status of the created jobs.  For
 example:
diff --git a/fio.h b/fio.h
index be684ca..9a991a8 100644
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
@@ -551,16 +550,20 @@ extern void reset_fio_state(void);
 extern int fio_options_parse(struct thread_data *, char **, int);
 extern void fio_keywords_init(void);
 extern int fio_cmd_option_parse(struct thread_data *, const char *, char *=
);
+extern int fio_cmd_ioengine_option_parse(struct thread_data *, const
char *, char *);
 extern void fio_fill_default_options(struct thread_data *);
 extern int fio_show_option_help(const char *);
+extern void fio_options_set_ioengine_opts(struct option
*long_options, struct thread_data *td);
 extern void fio_options_dup_and_init(struct option *);
-extern void options_mem_dupe(struct thread_data *);
-extern void options_mem_free(struct thread_data *);
+extern void fio_options_mem_dupe(struct thread_data *);
+extern void options_mem_dupe(void *data, struct fio_option *options);
 extern void td_fill_rand_seeds(struct thread_data *);
 extern void add_job_opts(const char **);
 extern char *num2str(unsigned long, int, int, int);
+extern int ioengine_load(struct thread_data *);

-#define FIO_GETOPT_JOB         0x89988998
+#define FIO_GETOPT_JOB         0x89000000
+#define FIO_GETOPT_IOENGINE    0x98000000
 #define FIO_NR_OPTIONS         (FIO_MAX_OPTS + 128)

 /*
diff --git a/init.c b/init.c
index ee6c139..9036b42 100644
--- a/init.c
+++ b/init.c
@@ -139,6 +139,11 @@ static struct option l_opts[FIO_NR_OPTIONS] =3D {
                .val            =3D 'c' | FIO_CLIENT_FLAG,
        },
        {
+               .name              =3D (char *) "enghelp",
+               .has_arg        =3D optional_argument,
+               .val                =3D 'i' | FIO_CLIENT_FLAG,
+       },
+       {
                .name           =3D (char *) "showcmd",
                .has_arg        =3D no_argument,
                .val            =3D 's' | FIO_CLIENT_FLAG,
@@ -278,7 +283,8 @@ static int setup_thread_area(void)
 /*
  * Return a free job structure.
  */
-static struct thread_data *get_new_job(int global, struct thread_data *par=
ent)
+static struct thread_data *get_new_job(int global, struct thread_data *par=
ent,
+                                      int preserve_eo)
 {
        struct thread_data *td;

@@ -297,10 +303,14 @@ static struct thread_data *get_new_job(int
global, struct thread_data *parent)
        td =3D &threads[thread_number++];
        *td =3D *parent;

+       td->io_ops =3D NULL;
+       if (!preserve_eo)
+               td->eo =3D NULL;
+
        td->o.uid =3D td->o.gid =3D -1U;

        dup_files(td, parent);
-       options_mem_dupe(td);
+       fio_options_mem_dupe(td);

        profile_add_hooks(td);

@@ -319,6 +329,8 @@ static void put_job(struct thread_data *td)
                log_info("fio: %s\n", td->verror);

        fio_options_free(td);
+       if (td->io_ops)
+               free_ioengine(td);

        memset(&threads[td->thread_number - 1], 0, sizeof(*td));
        thread_number--;
@@ -665,6 +677,62 @@ static int init_random_state(struct thread_data *td)
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
+               /*
+                * In cases where td->eo is set, clone it for a child threa=
d.
+                * This requires that the parent thread has the same ioengi=
ne,
+                * but that requirement must be enforced by the code which
+                * cloned the thread.
+                */
+               void *origeo =3D td->eo;
+               /*
+                * Otherwise use the default thread options.
+                */
+               if (!origeo && td !=3D &def_thread && def_thread.eo &&
+                   def_thread.io_ops->options =3D=3D td->io_ops->options)
+                       origeo =3D def_thread.eo;
+
+               options_init(td->io_ops->options);
+               td->eo =3D malloc(td->io_ops->option_struct_size);
+               /*
+                * Use the default thread as an option template if this use=
s the
+                * same options structure and there are non-default options
+                * used.
+                */
+               if (origeo) {
+                       memcpy(td->eo, origeo, td->io_ops->option_struct_si=
ze);
+                       options_mem_dupe(td->eo, td->io_ops->options);
+               } else {
+                       memset(td->eo, 0, td->io_ops->option_struct_size);
+                       fill_default_options(td->eo, td->io_ops->options);
+               }
+               *(struct thread_data **)td->eo =3D td;
+       }
+
+       return 0;
+}
+
+/*
  * Adds a job to the list of things todo. Sanitizes the various options
  * to make sure we don't have conflicts, and initializes various
  * members of td.
@@ -674,7 +742,6 @@ static int add_job(struct thread_data *td, const
char *jobname, int job_add_num)
        const char *ddir_str[] =3D { NULL, "read", "write", "rw", NULL,
                                   "randread", "randwrite", "randrw" };
        unsigned int i;
-       const char *engine;
        char fname[PATH_MAX];
        int numjobs, file_alloced;

@@ -695,12 +762,8 @@ static int add_job(struct thread_data *td, const
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
@@ -728,6 +791,13 @@ static int add_job(struct thread_data *td, const
char *jobname, int job_add_num)
        if (fixup_options(td))
                goto err;

+       /*
+        * IO engines only need this for option callbacks, and the address =
may
+        * change in subprocesses.
+        */
+       if (td->eo)
+               *(struct thread_data **)td->eo =3D NULL;
+
        if (td->io_ops->flags & FIO_DISKLESSIO) {
                struct fio_file *f;

@@ -814,7 +884,7 @@ static int add_job(struct thread_data *td, const
char *jobname, int job_add_num)
         */
        numjobs =3D td->o.numjobs;
        while (--numjobs) {
-               struct thread_data *td_new =3D get_new_job(0, td);
+               struct thread_data *td_new =3D get_new_job(0, td, 1);

                if (!td_new)
                        goto err;
@@ -862,11 +932,11 @@ void add_job_opts(const char **o)
                        sprintf(jobname, "%s", o[i] + 5);
                }
                if (in_global && !td_parent)
-                       td_parent =3D get_new_job(1, &def_thread);
+                       td_parent =3D get_new_job(1, &def_thread, 0);
                else if (!in_global && !td) {
                        if (!td_parent)
                                td_parent =3D &def_thread;
-                       td =3D get_new_job(0, td_parent);
+                       td =3D get_new_job(0, td_parent, 0);
                }
                if (in_global)
                        fio_options_parse(td_parent, (char **) &o[i], 1);
@@ -1001,7 +1071,7 @@ int parse_jobs_ini(char *file, int is_buf, int
stonewall_flag)
                        first_sect =3D 0;
                }

-               td =3D get_new_job(global, &def_thread);
+               td =3D get_new_job(global, &def_thread, 0);
                if (!td) {
                        ret =3D 1;
                        break;
@@ -1120,6 +1190,10 @@ static void usage(const char *name)
        printf("  --help\t\tPrint this page\n");
        printf("  --cmdhelp=3Dcmd\t\tPrint command help, \"all\" for all of=
"
                " them\n");
+       printf("  --enghelp=3Dengine\tPrint ioengine help, or list"
+               " available ioengines\n");
+       printf("  --enghelp=3Dengine,cmd\tPrint help for an ioengine"
+               " cmd\n");
        printf("  --showcmd\t\tTurn a job file into command line options\n"=
);
        printf("  --eta=3Dwhen\t\tWhen ETA estimate should be printed\n");
        printf("            \t\tMay be \"always\", \"never\" or \"auto\"\n"=
);
@@ -1318,6 +1392,12 @@ int parse_cmd_line(int argc, char *argv[])
                                do_exit++;
                        }
                        break;
+               case 'i':
+                       if (!cur_client) {
+                               fio_show_ioengine_help(optarg);
+                               do_exit++;
+                       }
+                       break;
                case 's':
                        dump_cmdline =3D 1;
                        break;
@@ -1387,12 +1467,28 @@ int parse_cmd_line(int argc, char *argv[])
                                if (is_section && skip_this_section(val))
                                        continue;

-                               td =3D get_new_job(global, &def_thread);
-                               if (!td)
+                               td =3D get_new_job(global, &def_thread, 1);
+                               if (!td || ioengine_load(td))
                                        return 0;
+                               fio_options_set_ioengine_opts(l_opts, td);
                        }

                        ret =3D fio_cmd_option_parse(td, opt, val);
+
+                       if (!ret && !strcmp(opt, "ioengine")) {
+                               free_ioengine(td);
+                               if (ioengine_load(td))
+                                       return 0;
+                               fio_options_set_ioengine_opts(l_opts, td);
+                       }
+                       break;
+               }
+               case FIO_GETOPT_IOENGINE: {
+                       const char *opt =3D l_opts[lidx].name;
+                       char *val =3D optarg;
+                       opt =3D l_opts[lidx].name;
+                       val =3D optarg;
+                       ret =3D fio_cmd_ioengine_option_parse(td, opt, val)=
;
                        break;
                }
                case 'w':
diff --git a/ioengine.h b/ioengine.h
index 044c4da..be74b66 100644
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
@@ -155,8 +157,11 @@ extern int __must_check
td_io_get_file_size(struct thread_data *, struct fio_fil
 extern struct ioengine_ops *load_ioengine(struct thread_data *, const char=
 *);
 extern void register_ioengine(struct ioengine_ops *);
 extern void unregister_ioengine(struct ioengine_ops *);
+extern void free_ioengine(struct thread_data *);
 extern void close_ioengine(struct thread_data *);

+extern int fio_show_ioengine_help(const char *engine);
+
 /*
  * io unit handling
  */
diff --git a/ioengines.c b/ioengines.c
index 7f4e104..e8ed871 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -152,13 +152,17 @@ struct ioengine_ops *load_ioengine(struct
thread_data *td, const char *name)
        return ret;
 }

-void close_ioengine(struct thread_data *td)
+/*
+ * For cleaning up an ioengine which never made it to init().
+ */
+void free_ioengine(struct thread_data *td)
 {
-       dprint(FD_IO, "close ioengine %s\n", td->io_ops->name);
+       dprint(FD_IO, "free ioengine %s\n", td->io_ops->name);

-       if (td->io_ops->cleanup) {
-               td->io_ops->cleanup(td);
-               td->io_ops->data =3D NULL;
+       if (td->eo && td->io_ops->options) {
+               options_free(td->io_ops->options, td->eo);
+               free(td->eo);
+               td->eo =3D NULL;
        }

        if (td->io_ops->dlhandle)
@@ -168,6 +172,18 @@ void close_ioengine(struct thread_data *td)
        td->io_ops =3D NULL;
 }

+void close_ioengine(struct thread_data *td)
+{
+       dprint(FD_IO, "close ioengine %s\n", td->io_ops->name);
+
+       if (td->io_ops->cleanup) {
+               td->io_ops->cleanup(td);
+               td->io_ops->data =3D NULL;
+       }
+
+       free_ioengine(td);
+}
+
 int td_io_prep(struct thread_data *td, struct io_u *io_u)
 {
        dprint_io_u(io_u, "prep");
@@ -501,3 +517,43 @@ int do_io_u_trim(struct thread_data *td, struct io_u *=
io_u)
        return 0;
 #endif
 }
+
+int fio_show_ioengine_help(const char *engine)
+{
+       struct flist_head *entry;
+       struct thread_data td;
+       char *sep;
+       int ret =3D 1;
+
+       if (!engine || !*engine) {
+               log_info("Available IO engines:\n");
+               flist_for_each(entry, &engine_list) {
+                       td.io_ops =3D flist_entry(entry, struct ioengine_op=
s,
+                                               list);
+                       log_info("\t%s\n", td.io_ops->name);
+               }
+               return 0;
+       }
+       sep =3D strchr(engine, ',');
+       if (sep) {
+               *sep =3D 0;
+               sep++;
+       }
+
+       memset(&td, 0, sizeof(td));
+
+       td.io_ops =3D load_ioengine(&td, engine);
+       if (!td.io_ops) {
+               log_info("IO engine %s not found\n", engine);
+               return 1;
+       }
+
+       if (td.io_ops->options)
+               ret =3D show_cmd_help(td.io_ops->options, sep);
+       else
+               log_info("IO engine %s has no options\n", td.io_ops->name);
+
+       free_ioengine(&td);
+
+       return ret;
+}
diff --git a/options.c b/options.c
index 84bf5ac..6352f0a 100644
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
@@ -595,14 +580,6 @@ static char *get_next_file_name(char **ptr)
        return start;
 }

-static int str_hostname_cb(void *data, const char *input)
-{
-       struct thread_data *td =3D data;
-
-       td->o.filename =3D strdup(input);
-       return 0;
-}
-
 static int str_filename_cb(void *data, const char *input)
 {
        struct thread_data *td =3D data;
@@ -881,12 +858,6 @@ static struct fio_option options[FIO_MAX_OPTS] =3D {
                .help   =3D "File(s) to use for the workload",
        },
        {
-               .name   =3D "hostname",
-               .type   =3D FIO_OPT_STR_STORE,
-               .cb     =3D str_hostname_cb,
-               .help   =3D "Hostname for net IO engine",
-       },
-       {
                .name   =3D "kb_base",
                .type   =3D FIO_OPT_INT,
                .off1   =3D td_var_offset(kb_base),
@@ -999,7 +970,6 @@ static struct fio_option options[FIO_MAX_OPTS] =3D {
 #ifdef FIO_HAVE_LIBAIO
                          { .ival =3D "libaio",
                            .help =3D "Linux native asynchronous IO",
-                           .cb   =3D str_libaio_cb,
                          },
 #endif
 #ifdef FIO_HAVE_POSIXAIO
@@ -1015,7 +985,7 @@ static struct fio_option options[FIO_MAX_OPTS] =3D {
 #ifdef FIO_HAVE_WINDOWSAIO
                          { .ival =3D "windowsaio",
                            .help =3D "Windows native asynchronous IO"
-                         },
+                         },
 #endif
                          { .ival =3D "mmap",
                            .help =3D "Memory mapped IO"
@@ -2137,33 +2107,26 @@ static struct fio_option options[FIO_MAX_OPTS] =3D =
{
 };

 static void add_to_lopt(struct option *lopt, struct fio_option *o,
-                       const char *name)
+                       const char *name, int val)
 {
        lopt->name =3D (char *) name;
-       lopt->val =3D FIO_GETOPT_JOB;
+       lopt->val =3D val;
        if (o->type =3D=3D FIO_OPT_STR_SET)
                lopt->has_arg =3D no_argument;
        else
                lopt->has_arg =3D required_argument;
 }

-void fio_options_dup_and_init(struct option *long_options)
+static void options_to_lopts(struct fio_option *opts,
+                             struct option *long_options,
+                             int i, int option_type)
 {
-       struct fio_option *o;
-       unsigned int i;
-
-       options_init(options);
-
-       i =3D 0;
-       while (long_options[i].name)
-               i++;
-
-       o =3D &options[0];
+       struct fio_option *o =3D &opts[0];
        while (o->name) {
-               add_to_lopt(&long_options[i], o, o->name);
+               add_to_lopt(&long_options[i], o, o->name, option_type);
                if (o->alias) {
                        i++;
-                       add_to_lopt(&long_options[i], o, o->alias);
+                       add_to_lopt(&long_options[i], o, o->alias, option_t=
ype);
                }

                i++;
@@ -2172,6 +2135,43 @@ void fio_options_dup_and_init(struct option
*long_options)
        }
 }

+void fio_options_set_ioengine_opts(struct option *long_options,
+                                  struct thread_data *td)
+{
+       unsigned int i;
+
+       i =3D 0;
+       while (long_options[i].name) {
+               if (long_options[i].val =3D=3D FIO_GETOPT_IOENGINE) {
+                       memset(&long_options[i], 0, sizeof(*long_options));
+                       break;
+               }
+               i++;
+       }
+
+       /*
+        * Just clear out the prior ioengine options.
+        */
+       if (!td || !td->eo)
+               return;
+
+       options_to_lopts(td->io_ops->options, long_options, i,
+                        FIO_GETOPT_IOENGINE);
+}
+
+void fio_options_dup_and_init(struct option *long_options)
+{
+       unsigned int i;
+
+       options_init(options);
+
+       i =3D 0;
+       while (long_options[i].name)
+               i++;
+
+       options_to_lopts(options, long_options, i, FIO_GETOPT_JOB);
+}
+
 struct fio_keyword {
        const char *word;
        const char *desc;
@@ -2389,18 +2389,53 @@ static char **dup_and_sub_options(char **opts,
int num_opts)

 int fio_options_parse(struct thread_data *td, char **opts, int num_opts)
 {
-       int i, ret;
+       int i, ret, unknown;
        char **opts_copy;

        sort_options(opts, options, num_opts);
        opts_copy =3D dup_and_sub_options(opts, num_opts);

-       for (ret =3D 0, i =3D 0; i < num_opts; i++) {
-               ret |=3D parse_option(opts_copy[i], opts[i], options, td);
+       for (ret =3D 0, i =3D 0, unknown =3D 0; i < num_opts; i++) {
+               struct fio_option *o;
+               int newret =3D parse_option(opts_copy[i], opts[i], options,=
 &o,
+                                         td);

-               if (opts_copy[i])
+               if (opts_copy[i]) {
+                       if (newret && !o) {
+                               unknown++;
+                               continue;
+                       }
                        free(opts_copy[i]);
-               opts_copy[i] =3D NULL;
+                       opts_copy[i] =3D NULL;
+               }
+
+               ret |=3D newret;
+       }
+
+       if (unknown) {
+               ret |=3D ioengine_load(td);
+               if (td->eo) {
+                       sort_options(opts_copy, td->io_ops->options, num_op=
ts);
+                       opts =3D opts_copy;
+               }
+               for (i =3D 0; i < num_opts; i++) {
+                       struct fio_option *o =3D NULL;
+                       int newret =3D 1;
+                       if (!opts_copy[i])
+                               continue;
+
+                       if (td->eo)
+                               newret =3D parse_option(opts_copy[i], opts[=
i],
+                                                     td->io_ops->options, =
&o,
+                                                     td->eo);
+
+                       ret |=3D newret;
+                       if (!o)
+                               log_err("Bad option <%s>\n", opts[i]);
+
+                       free(opts_copy[i]);
+                       opts_copy[i] =3D NULL;
+               }
        }

        free(opts_copy);
@@ -2412,6 +2447,12 @@ int fio_cmd_option_parse(struct thread_data
*td, const char *opt, char *val)
        return parse_cmd_option(opt, val, options, td);
 }

+int fio_cmd_ioengine_option_parse(struct thread_data *td, const char *opt,
+                               char *val)
+{
+       return parse_cmd_option(opt, val, td->io_ops->options, td);
+}
+
 void fio_fill_default_options(struct thread_data *td)
 {
        fill_default_options(td, options);
@@ -2422,28 +2463,35 @@ int fio_show_option_help(const char *opt)
        return show_cmd_help(options, opt);
 }

-/*
- * dupe FIO_OPT_STR_STORE options
- */
-void options_mem_dupe(struct thread_data *td)
+void options_mem_dupe(void *data, struct fio_option *options)
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
@@ -2528,4 +2576,9 @@ void del_opt_posval(const char *optname, const char *=
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
index 7f7851c..9a65e31 100644
--- a/parse.c
+++ b/parse.c
@@ -503,7 +503,7 @@ static int __handle_option(struct fio_option *o,
const char *ptr, void *data,

                posval_sort(o, posval);

-               if (!o->posval[0].ival) {
+               if ((o->roff1 || o->off1) && !o->posval[0].ival) {
                        vp =3D NULL;
                        goto match;
                }
@@ -728,7 +728,7 @@ static int handle_option(struct fio_option *o,
const char *__ptr, void *data)
        return ret;
 }

-static struct fio_option *get_option(const char *opt,
+static struct fio_option *get_option(char *opt,
                                     struct fio_option *options, char **pos=
t)
 {
        struct fio_option *o;
@@ -738,7 +738,7 @@ static struct fio_option *get_option(const char *opt,
        if (ret) {
                *post =3D ret;
                *ret =3D '\0';
-               ret =3D (char *) opt;
+               ret =3D opt;
                (*post)++;
                strip_blank_end(ret);
                o =3D find_option(options, ret);
@@ -752,24 +752,27 @@ static struct fio_option *get_option(const char *opt,

 static int opt_cmp(const void *p1, const void *p2)
 {
-       struct fio_option *o1, *o2;
-       char *s1, *s2, *foo;
+       struct fio_option *o;
+       char *s, *foo;
        int prio1, prio2;

-       s1 =3D strdup(*((char **) p1));
-       s2 =3D strdup(*((char **) p2));
-
-       o1 =3D get_option(s1, fio_options, &foo);
-       o2 =3D get_option(s2, fio_options, &foo);
-
        prio1 =3D prio2 =3D 0;
-       if (o1)
-               prio1 =3D o1->prio;
-       if (o2)
-               prio2 =3D o2->prio;

-       free(s1);
-       free(s2);
+       if (*(char **)p1) {
+               s =3D strdup(*((char **) p1));
+               o =3D get_option(s, fio_options, &foo);
+               if (o)
+                       prio1 =3D o->prio;
+               free(s);
+       }
+       if (*(char **)p2) {
+               s =3D strdup(*((char **) p2));
+               o =3D get_option(s, fio_options, &foo);
+               if (o)
+                       prio2 =3D o->prio;
+               free(s);
+       }
+
        return prio2 - prio1;
 }

@@ -798,24 +801,29 @@ int parse_cmd_option(const char *opt, const char *val=
,
        return 1;
 }

-int parse_option(const char *opt, const char *input,
-                struct fio_option *options, void *data)
+int parse_option(char *opt, const char *input,
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
+               if (post) {
+                       int len =3D strlen(opt);
+                       if (opt + len + 1 !=3D post)
+                               memmove(opt + len + 1, post, strlen(post));
+                       opt[len] =3D '=3D';
+               }
                return 1;
        }

-       if (!handle_option(o, post, data)) {
+       if (!handle_option(*o, post, data)) {
                return 0;
        }

@@ -1053,7 +1061,7 @@ void options_free(struct fio_option *options, void *d=
ata)
        dprint(FD_PARSE, "free options\n");

        for (o =3D &options[0]; o->name; o++) {
-               if (o->type !=3D FIO_OPT_STR_STORE)
+               if (o->type !=3D FIO_OPT_STR_STORE || !o->off1)
                        continue;

                ptr =3D td_var(data, o->off1);
diff --git a/parse.h b/parse.h
index 091923e..4edf75e 100644
--- a/parse.h
+++ b/parse.h
@@ -65,7 +65,7 @@ struct fio_option {

 typedef int (str_cb_fn)(void *, char *);

-extern int parse_option(const char *, const char *, struct fio_option
*, void *);
+extern int parse_option(char *, const char *, struct fio_option *,
struct fio_option **, void *);
 extern void sort_options(char **, struct fio_option *, int);
 extern int parse_cmd_option(const char *t, const char *l, struct
fio_option *, void *);
 extern int show_cmd_help(struct fio_option *, const char *);

