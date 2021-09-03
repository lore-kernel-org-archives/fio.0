Return-Path: <prvs=873f0fbe3=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 00/11] Improve io_uring and libaio IO priority support
Date: Fri, 3 Sep 2021 15:20:19 +0000
Message-ID: <20210903152012.18035-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

This series improves io_uring/libaio engine support for IO priority,
adding options to allow for mixed priority workloads to be specified
more easily and to match the kernel supported IO priority features.

This series is based on Damien's V1 series which can be found here:
https://www.spinics.net/lists/fio/msg09614.html

Major changes since v1:

- Rename new options:
aioprio -> cmdprio
aioprioclass -> cmdprio_class
aioprio_bssplit -> cmdprio_bssplit.
Since these options are all related to cmdprio_percentage, it makes sense
to keep the cmdprio prefix for these new options.
Renaming also makes it more clear that these are not libaio specifc options=
.

- Added io_uring support for these new options.
All these new options works for ioengine=3Dlibaio and ioengine=3Dio_uring

- Added a new helper file: engines/cmdprio.h and moved as much common code
that I could share between io_uring and libaio in there.

Kept Damien's authorship as I feel that I haven't changed the original code
sufficiently to warrant an authorship change.


Comments are welcome!

Kind regards,
Niklas

Damien Le Moal (11):
  manpage: fix formatting
  manpage: fix definition of prio and prioclass options
  tools: fiograph: do not overwrite input script file
  os: introduce ioprio_value() helper
  options: make parsing functions available to ioengines
  libaio,io_uring: improve cmdprio_percentage option
  libaio,io_uring: introduce cmdprio_class and cmdprio options
  libaio,io_uring: introduce cmdprio_bssplit
  libaio,io_uring: relax cmdprio_percentage constraints
  fio: Introduce the log_prio option
  examples: add examples for cmdprio_* IO priority options

 HOWTO                           |  59 ++++++++++---
 backend.c                       |   1 +
 cconv.c                         |   2 +
 client.c                        |   2 +
 engines/cmdprio.h               | 144 ++++++++++++++++++++++++++++++
 engines/filecreate.c            |   2 +-
 engines/filedelete.c            |   2 +-
 engines/filestat.c              |   2 +-
 engines/io_uring.c              | 152 +++++++++++++++++++++++++-------
 engines/libaio.c                | 125 ++++++++++++++++++++++----
 eta.c                           |   2 +-
 examples/cmdprio-bssplit.fio    |  17 ++++
 examples/cmdprio-bssplit.png    | Bin 0 -> 45606 bytes
 examples/cmdprio-percentage.fio |  17 ++++
 examples/cmdprio-percentage.png | Bin 0 -> 46271 bytes
 fio.1                           |  73 +++++++++++----
 fio.h                           |   5 ++
 init.c                          |   4 +
 io_u.c                          |  14 ++-
 io_u.h                          |  10 ++-
 iolog.c                         |  45 +++++++---
 iolog.h                         |  16 +++-
 options.c                       |  50 ++++++-----
 os/os-android.h                 |  20 +++--
 os/os-dragonfly.h               |   1 +
 os/os-linux.h                   |  20 +++--
 os/os.h                         |   4 +
 server.h                        |   3 +-
 stat.c                          |  75 ++++++++--------
 stat.h                          |   9 +-
 thread_options.h                |  19 ++++
 tools/fiograph/fiograph.conf    |   4 +-
 tools/fiograph/fiograph.py      |   4 +-
 33 files changed, 724 insertions(+), 179 deletions(-)
 create mode 100644 engines/cmdprio.h
 create mode 100644 examples/cmdprio-bssplit.fio
 create mode 100644 examples/cmdprio-bssplit.png
 create mode 100644 examples/cmdprio-percentage.fio
 create mode 100644 examples/cmdprio-percentage.png

--=20
2.31.1

