Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:40293 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758992AbZDWSeg (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 23 Apr 2009 14:34:36 -0400
Date: Thu, 23 Apr 2009 20:34:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: request for job files
Message-ID: <20090423183435.GK4593@kernel.dk>
References: <20090422132257.GR4593@kernel.dk> <f3177b9e0904221332w887ef28l7e25959fb24892c8@mail.gmail.com> <20090423055044.GI4593@kernel.dk> <f3177b9e0904230848g57b546bco735131128ce0a786@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3177b9e0904230848g57b546bco735131128ce0a786@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: fio@vger.kernel.org

On Thu, Apr 23 2009, Chris Worley wrote:
> Jens,
> 
> Thanks for the tips!
> 
> One other question, in the first case where I use only one group with
> multiple file names, where I'm summing 10% of the disks sizes, is fio
> going to evenly distribute that size among the disks/files?  That
> seems to be the case, but I'm not sure.

Yes, it'll distribute evenly. Also see the file_service_type option.

-- 
Jens Axboe

