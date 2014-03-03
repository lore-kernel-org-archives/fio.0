Return-Path: <axboe@kernel.dk>
Message-ID: <53149EF3.7020005@kernel.dk>
Date: Mon, 03 Mar 2014 08:25:39 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: regression since 2.1.3 (solaris/zfs)
References: <1E602C14-0C00-4258-94C2-8F16A56C509D@coraid.com>
In-Reply-To: <1E602C14-0C00-4258-94C2-8F16A56C509D@coraid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Robin P. Blanchard" <robin@coraid.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/02/2014 07:59 AM, Robin P. Blanchard wrote:
> My config file has direct=0, which until 2.1.4 worked as expected.
 > Things seem to regress since.
>
> I apologize in advance if this has already been reported. Please
 > let me know what I can do to further help (truss/debug).

This isn't a known issue, so thanks for reporting it. The easiest way to 
debug this is to git bisect it. Looks like you are running from the tar 
balls, but I assume you have git installed? I'm assuming fio-2.1.3 
worked for you - if not, just replace fio-2.1.3 in the below with 
whatever latest version did work. If you do, the cheat sheet is 
something ala:

$ git clone git://git.kernel.dk/fio
$ cd fio; make
$ git bisect start
$ git bisect good fio-2.1.3
$ git bisect bad fio-2.1.4

This starts the bisect series, now do:

$ make clean; make

and re-run your direct=0 job file. If it worked, then you do

$ git bisect good

and if not, you do git bisect bad instead. This gets you a new point in 
the tree to test, so repeat the make clean; make and re-run the test.
Keep doing this good/bad iteration until fio tells you what commit broke 
the test for you. Then send those results here!

-- 
Jens Axboe


