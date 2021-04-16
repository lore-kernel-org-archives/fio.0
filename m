Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] backend: fix switch_ioscheduler()
References: <20210415021654.232698-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <7c088b38-c717-a6ea-6748-75fbba98cc43@kernel.dk>
Date: Fri, 16 Apr 2021 10:26:09 -0600
MIME-Version: 1.0
In-Reply-To: <20210415021654.232698-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 4/14/21 8:16 PM, Damien Le Moal wrote:
> The backend.c function switch_ioscheduler() suffers from several
> problems:
> 1) This function only considers the first file of a job. For jobs using
>    multiple files, the ioscheduler switch will done only for that file.
> 2) If the job file is a character device, a pipe or a regular file for
>    which the hosting block device file cannot be determined (e.g. a
>    remote file), thring to switch the IO scheduler causes a crash as the
>    file disk_util field is NULL.
> Fix both problems by introducing the helper function set_ioscheduler()
> and changing switch_ioscheduler() to repeatdly call this helper for all
> files of the job, ignoring character device files, pipe files and files
> without a hosting device information.
> 
> Also update the man page to better explain when the ioscheduler option
> applies.

Thanks! Applied.

-- 
Jens Axboe


