Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:58885 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbZDTGlT (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 20 Apr 2009 02:41:19 -0400
Date: Mon, 20 Apr 2009 08:41:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [bug] Crash with multiple file names
Message-ID: <20090420064117.GQ4593@kernel.dk>
References: <ed038eb20904191807h6ff3427dn83684a723c95e13c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed038eb20904191807h6ff3427dn83684a723c95e13c@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Henrik Lunde <chlunde@ping.uio.no>
Cc: fio@vger.kernel.org

On Mon, Apr 20 2009, Carl Henrik Lunde wrote:
> Hi!  fio crashed with this configuration.  I notice there are a
> multiple variables counting the number of files, so I don't know which
> one to use.  nr_files *seems* safe?
> 
> diff --git a/filesetup.c b/filesetup.c
> index af23191..eb8774a 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -685,8 +685,8 @@ int add_file(struct thread_data *td, const char *fname)
> 
>         f->fd = -1;
> 
> -       if (td->files_size <= td->files_index) {
> -               int new_size = td->o.nr_files;
> +       if (td->files_size <= td->o.nr_files) {
> +               int new_size = td->o.nr_files + 1;
> 
>                 dprint(FD_FILE, "resize file array to %d files\n", new_size);

Woops, that is indeed an off-by-one! I have added your patch, thanks.

Your reading of the code is correct. ->o.nr_files is the total number of
files.

-- 
Jens Axboe

