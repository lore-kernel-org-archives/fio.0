Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45856 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3IFQBF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 6 Sep 2013 12:01:05 -0400
Message-ID: <5229FC39.50905@kernel.dk>
Date: Fri, 06 Sep 2013 10:00:57 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio --showcmd fails if directory= does not exist
References: <20130906123812.GB9122@twin.jikos.cz>
In-Reply-To: <20130906123812.GB9122@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: dave@jikos.cz
Cc: fio@vger.kernel.org

On 09/06/2013 06:38 AM, David Sterba wrote:
> Hi,
> 
> I'm using "fio --showcmd file.job" to convert a script to plain
> commandline arguments and this fails if the directory specified in job
> file does not exist. While this has to be an error if the job is being
> executed, it should not be in context of --showcmd.
> 
> To reproduce:
> $ cat job.fio
> [global]
> directory=/x
> 
> $ fio --showcmd job.fio
> fio: /x is not a directory
> fio: failed parsing directory=/x
> fio: job global dropped
> 
> Expected output:
> fio --directory=/x

That's definitely a bug, the callbacks should not verify anything if we
are only in dump or parse only mode. I've committed a fix.

-- 
Jens Axboe

