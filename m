Return-Path: <daniel.menzel@menzel-it.net>
From: Daniel Menzel <daniel.menzel@menzel-it.net>
Subject: io_uring on CentOS8?
Message-ID: <6d57985d-b784-f9a5-68d0-3a0c3857b4a4@menzel-it.net>
Date: Sun, 14 Feb 2021 16:17:43 +0100
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------A640E2AA15C94B047AFC147D"
Content-Language: en-US
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------A640E2AA15C94B047AFC147D
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

/Somehow it seems as if I'm receiving messages from the mailing list -
but mine do not seem to get through. So I'm trying again./

Hi,

currently I started testing fairly fast NVMe-drives and I for the first
time I dealt with the question whether the io engine is sufficient (up
till now I just the default /libaio/). I found some information on
io_uring online and now tried to switch to that engine:

fio --bs=1M --rw=randwrite --numjobs=1 --iodepth=1  --size=10000M
--filename=/dev/nvme0n1 --name=mylittletest --direct=1 --fsync=1 
--refill_buffers --ioengine=io_uring --group_reporting --fallocate=none
--runtime=60 --time_based --hipri

But it crashes with the following information: fio: pid=2490,
err=38/file:engines/io_uring.c:699, func=io_queue_init, error=Function
not implemented

My system:

 1. fio-3.25
 2. CentOS8 (Kernel 4.18.0-240.1.1.el8_3.x86_64)
 3. I have installed the packes liburing and liburing-devel

Am I doing something wrong?

Kind regards
Daniel


--------------A640E2AA15C94B047AFC147D
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><i>Somehow it seems as if I'm receiving messages from the mailing
        list - but mine do not seem to get through. So I'm trying again.</i><br>
    </p>
    <p>Hi,</p>
    <p>currently I started testing fairly fast NVMe-drives and I for the
      first time I dealt with the question whether the io engine is
      sufficient (up till now I just the default <i>libaio</i>). I
      found some information on io_uring online and now tried to switch
      to that engine:</p>
    <p><tt>fio --bs=1M --rw=randwrite --numjobs=1 --iodepth=1 
        --size=10000M --filename=/dev/nvme0n1 --name=mylittletest
        --direct=1 --fsync=1  --refill_buffers --ioengine=io_uring
        --group_reporting --fallocate=none --runtime=60 --time_based
        --hipri</tt><br>
    </p>
    <p>But it crashes with the following information: <tt>fio:
        pid=2490, err=38/<a class="moz-txt-link-freetext"
          href="file:engines/io_uring.c:699" moz-do-not-send="true">file:engines/io_uring.c:699</a>,
        func=io_queue_init, error=Function not implemented</tt></p>
    <p>My system:</p>
    <ol>
      <li>fio-3.25</li>
      <li>CentOS8 (Kernel <tt>4.18.0-240.1.1.el8_3.x86_64</tt>)</li>
      <li>I have installed the packes <tt>liburing</tt> and <tt>liburing-devel</tt></li>
    </ol>
    <p>Am I doing something wrong?</p>
    <p>Kind regards<br>
      Daniel<br>
    </p>
  </body>
</html>

--------------A640E2AA15C94B047AFC147D--

