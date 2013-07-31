Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57919 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3GaSfy (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 31 Jul 2013 14:35:54 -0400
Message-ID: <51F958E8.1000904@kernel.dk>
Date: Wed, 31 Jul 2013 12:35:20 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [Pull Request] Updating tools
References: <51F7ACC3.2000904@enovance.com> <51F8E89E.4060208@enovance.com>
In-Reply-To: <51F8E89E.4060208@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 07/31/2013 04:36 AM, Erwan Velu wrote:
> Dear Jens,
> 
> I've been updating my branch to add a new feature and some visual
> improvements.
> 
> The main feature is if more than one file is matching the pattern, a new
> set of graphing is generated allowing traces comparaisons on the same
> graph as does fio_generate_plots
> 
> I've been adding sample files in the three moods (raw/smooth/trend) as
> an attachement.

Looks good!

> That's a good addition to the existing plotting I did with fio2gnuplot.
> Cheers,
> Erwan
> 
> The following changes since commit
> bf974737b15bad8d740f10503e9eab6e0b420aa2:
> 
>   Update sample atomic write job file (2013-07-26 13:11:52 -0600)
> 
> are available in the git repository at:
> 
>   git@github.com:enovance/fio.git erwan/outputdir

Thanks, pulled.

-- 
Jens Axboe

