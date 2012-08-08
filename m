Return-Path: <kyle.hailey@delphix.com>
MIME-Version: 1.0
In-Reply-To: <20120807144721.GF12248@splice>
References: <20120807010300.GD12248@splice> <50211B6A.2070505@kernel.dk> <20120807144721.GF12248@splice>
From: Kyle Hailey <kyle.hailey@delphix.com>
Date: Tue, 7 Aug 2012 22:26:53 -0700
Message-ID: <CACiQ3FBAo7PDL9hcZTWtJBAJA40BcdM9XKX87x=fv4PqODu0-g@mail.gmail.com>
Subject: Re: generating latency logs
Content-Type: text/plain; charset=ISO-8859-1
To: Mike Ryan <mike.ryan@inktank.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

very cool, so if I add the changes to init.c and run

    fio --latency-log --output  test.job

I get extra four  files

    -rw-r--r--  1 me staff   14937 Aug  8  2012 fiotest_lat.log
    -rw-r--r--  1 me staff       0 Aug  8  2012 fiotest_slat.log
    -rw-r--r--  1 me staff   14932 Aug  8  2012 fiotest_clat.log
    -rw-r--r--  1 me staff 4194304 Aug  8  2012 fiotest.1.0

What's the format?

    $ more fiotest_lat*
      1, 19, 1, 4096
      1, 18, 1, 4096
      1, 8, 1, 4096
      1, 7, 1, 4096
      1, 7, 1, 4096

What's the format? OK, found http://www.spinics.net/lists/fio/msg01064.html

Format of entries is:

           time, rate/latency, data direction, block size

     Time: in milliseconds. Bandwidth logs are usually 500 or 1000ms apart; that
     can be controlled by the config file with "bwavgtime=[x ms]".

      Rate/latency: for bandwidth, this is in KB/sec. For latency, it's
      microseconds.

      Data direction: 0 is read, 1 is write.

      Block size: block size of IOs in bytes.


what is the format of the file fiotest.1.0 ?
Is there a way to get the latency files without this file to avoid too
much output.


Thanks

- Kyle

On Tue, Aug 7, 2012 at 7:47 AM, Mike Ryan <mike.ryan@inktank.com> wrote:
>
> On Tue, Aug 07, 2012 at 03:43:06PM +0200, Jens Axboe wrote:
> > >   fio --latency-log=/tmp/log --output=/tmp/log random_write.fio
> >
> > The latency/bw logs are named from the job name, so you can't actually
> > give it a specific name with the (global) command line option. You'd
> > need to use the job option to do that.
>
> The argument requires an option. It appears that option is discarded.
>
> > That said, it does look broken in that we don't inherit the global
> > setting. Does the below make it work?
>
> Yes! The files are named log_lat.log, log_slat.log, and log_clat.log.
> They are not named after the job.
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
- Kyle

O: +1.415.341.3430
F: +1.650.494.1676
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com

