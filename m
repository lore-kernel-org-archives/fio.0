Return-Path: <fio-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20326 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752695AbdFMVpK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Jun 2017 17:45:10 -0400
From: "Harris, James R" <james.r.harris@intel.com>
Subject: Re: [PATCH] set td->io_ops to NULL before dlclose()
Date: Tue, 13 Jun 2017 21:45:09 +0000
Message-ID: <F09DAC25-77C9-473F-ACC8-B797A1CDE930@intel.com>
References: <20170613194542.136566-1-james.r.harris@intel.com>
In-Reply-To: <20170613194542.136566-1-james.r.harris@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <786FD387642F1B47B029D93F0AF952C0@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>


> On Jun 13, 2017, at 12:45 PM, Harris, James R <james.r.harris@intel.com> wrote:
> 
> If using ioengine=/path/to/ioengine to dynamically load
> an ioengine, there is a race between free_ioengine()'s
> dlclose() and the td->io_ops dereference in reap_threads().
> 
> To resolve, td->io_ops must be set to NULL before calling
> dlclose() - this ensures the name check in reap_threads()
> does not try to reference memory no longer accessible due
> to the ioengine getting closed.
> 
> Signed-off-by: Jim Harris <james.r.harris@intel.com>
> ---
> ioengines.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ioengines.c b/ioengines.c
> index c90a2ca5..6caf73da 100644
> --- a/ioengines.c
> +++ b/ioengines.c
> @@ -170,10 +170,10 @@ void free_ioengine(struct thread_data *td)
> 		td->eo = NULL;
> 	}
> 
> +	td->io_ops = NULL;
> +
> 	if (td->io_ops_dlhandle)
> 		dlclose(td->io_ops_dlhandle);
> -
> -	td->io_ops = NULL;
> }
> 
> void close_ioengine(struct thread_data *td)
> -- 
> 2.12.2
> 

Please ignore.  This only narrows the race window - it does not close it.

