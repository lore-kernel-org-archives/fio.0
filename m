Return-Path: <axboe@kernel.dk>
Received: from [192.168.3.11] (66.29.187.50.static.utbb.net. [66.29.187.50])
        by mx.google.com with ESMTPSA id ow7sm8263281pbc.30.2014.09.27.13.39.36
        for <fio@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Sep 2014 13:39:37 -0700 (PDT)
Message-ID: <54272087.10907@kernel.dk>
Date: Sat, 27 Sep 2014 14:39:35 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: New tools and changes
References: <54271828.2040005@kernel.dk>
In-Reply-To: <54271828.2040005@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi,

I forgot to mention another handy change that went in recently - fio now 
supports including files from job files. This should make it easier to 
manage a test harness of fio files, since you can have more manageable 
files with a global (or per-host, whatever) include fio that has options 
for that particular instance. It's pretty simple to use, here's the 
section that was added to the HOWTO to explain it:

-----------

When fio is utilized as a basis of any reasonably large test suite, it 
might be desirable to share a set of standardized settings across 
multiple job files. Instead of copy/pasting such settings, any section 
may pull in an external .fio file with 'include filename' directive, as 
in the following example:

; -- start job file including.fio --
[global]
filename=/tmp/test
filesize=1m
include glob-include.fio

[test]
rw=randread
bs=4k
time_based=1
runtime=10
include test-include.fio
; -- end job file including.fio --

; -- start job file glob-include.fio --
thread=1
group_reporting=1
; -- end job file glob-include.fio --

; -- start job file test-include.fio --
ioengine=libaio
iodepth=4
; -- end job file test-include.fio --

Settings pulled into a section apply to that section only (except global
section). Include directives may be nested in that any included file may
contain further include directive(s). Include files may not contain []
sections.

--------

This feature courtesy of Andrey Kuzmin <andrey.v.kuzmin@gmail.com> who 
did all the work to make this feasible.

-- 
Jens Axboe


