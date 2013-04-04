Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52852
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764040Ab3DDSTy (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 4 Apr 2013 14:19:54 -0400
Date: Thu, 4 Apr 2013 20:19:46 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: How to re-use default sequential filenames?
Message-ID: <20130404181946.GD9683@kernel.dk>
References: <515DAA33.4000009@warnerbros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515DAA33.4000009@warnerbros.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alan Hagge <Alan.Hagge@warnerbros.com>
Cc: fio@vger.kernel.org

On Thu, Apr 04 2013, Alan Hagge wrote:
> I'm trying to put together a test of the write and read speed to some new
> SAN storage.  Our workflow involves writing large numbers of 12 MiB files
> (on the order of 20,000 or so) at a time.  I'd like to set up a config file
> section that will write all 20,000 files then read all 20,000 files and
> report on the write performance and the read performance (separately).
> 
> I've tried something like this:
> 
> [global]
> blocksize=4m
> filesize=12m
> nrfiles=20000
> openfiles=1
> file_service_type=sequential
> create_on_open=1
> ioengine=posixaio
> 
> [write]
> rw=write
> 
> [read]
> stonewall
> rw=read
> 
> But the issue is that the files get created with default filenames
> (write.1.1, write.1.2, etc.), so that when the read job is run, it can't
> find any files (since it expects the files to be named read.1.1, read.1.2,
> etc.).  If I try to specify the "filename=" option in either section, fio no
> longer appends the ".<thread>.<sequence>" to the filename, but rather tries
> to do all I/O to a single file.
> 
> Is there a syntax for the "filename=" option that will allow me to specify a
> different root filename, but still use the ".<thread>.<sequence>" naming
> convention?  Failing that, is there any other way to accomplish my goal?

Good question, and no, you can't currently do that. But you should be
able to do that. Fio has no current option for specifying the naming. We
could have a fileprefix= option that allows you to set that.

So we currently have two options. The first option is that you take on
this task. The file name (if not given with filename=) is generated in
init.c:add_job(), here:

	if (!td->o.filename && !td->files_index && !td->o.read_iolog_file) {
		file_alloced = 1;

		if (td->o.nr_files == 1 && exists_and_not_file(jobname))
			add_file(td, jobname);
		else {
			for (i = 0; i < td->o.nr_files; i++) {
				sprintf(fname, "%s.%d.%d", jobname,
							td->thread_number, i);
				add_file(td, fname);
			}
		}
	}

Options are pretty easy to add, basically just an entry in the
fio_option options[] array in options.c with pretty much
self-explanatory fields. Add matching string type in fio.h to
thread_options{ }.

The other option is that you claim that you are not a programmer, and
then you are at the mercy of someone else (most likely me!) doing it for
you. Since this is a good feature request, I can be talked into that as
well.

Let me know.

-- 
Jens Axboe

