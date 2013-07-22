Return-Path: <sbohrer@rgmadvisors.com>
Date: Mon, 22 Jul 2013 09:54:56 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: Re: [PATCH 1/5] net: Add UDP multicast support
Message-ID: <20130722145456.GA3509@sbohrermbp13-local.rgmadvisors.com>
References: <1374258250-9801-1-git-send-email-sbohrer@rgmadvisors.com>
 <20130720030726.GA28005@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <20130720030726.GA28005@kernel.dk>
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, tomk@rgmadvisors.com
List-ID: <fio@vger.kernel.org>

On Fri, Jul 19, 2013 at 09:07:26PM -0600, Jens Axboe wrote:
> On Fri, Jul 19 2013, Shawn Bohrer wrote:
> > Allow UDP readers to listen to UDP multicast traffic if hostname is set
> > to a valid UDP multicast address.
> 
> Looks good! Can I get you to include a sample job file as well, plus
> update the fio.1 man page in parallel with the HOWTO too?

Hi Jens,

Take a closer look, patches 1,2,3 already update fio.1 and HOWTO.  I'll
send a follow up patch with an example job file.

--
Shawn

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

