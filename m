Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: io_u_log_error ddir name mismatch
Date: Tue, 16 Sep 2014 22:24:59 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C8469C@G9W0745.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "Jens Axboe <axboe@kernel.dk> (axboe@kernel.dk)" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

The names in io_u_log_error:
       const char *msg[] =3D { "read", "write", "sync", "datasync",
                               "sync_file_range", "wait", "trim" };

which are printed with
	log_err (msg[io_u->ddir]);

don't match the enum values for io_u->ddir:

enum fio_ddir {
        DDIR_READ =3D 0,
        DDIR_WRITE =3D 1,
        DDIR_TRIM =3D 2,
        DDIR_RWDIR_CNT =3D 3,
        DDIR_SYNC =3D 3,
        DDIR_DATASYNC,
        DDIR_SYNC_FILE_RANGE,
        DDIR_WAIT,
        DDIR_INVAL =3D -1,
};

struct io_u {
        enum fio_ddir ddir;
...

Maybe TRIM was moved earlier at some point?

My test cases just generate reads and writes, so I don't have a=20
test case to validate a patch.

---
Rob Elliott    HP Server Storage



