Return-Path: <ecomar@uk.ibm.com>
In-Reply-To: <20130522122525.GK9714@kernel.dk>
References: <OF1E75BC9A.821D96E0-ON80257B6F.003CB4BE-80257B6F.003E2AAA@uk.ibm.com> <20130518122211.GM19781@kernel.dk> <OF4E37C571.40B0273E-ON80257B6F.005B05C5-80257B6F.005DC361@uk.ibm.com> <OFD80C407E.DC45623D-ON80257B6F.007F5485-80257B6F.007FC70E@uk.ibm.com> <OFE288D6C7.BEB7BBEB-ON80257B73.002E3467-80257B73.002E896D@uk.ibm.com> <20130522085736.GE9714@kernel.dk> <OF4C0E9045.FB0B29B3-ON80257B73.0036DB50-80257B73.00373934@uk.ibm.com> <20130522101554.GG9714@kernel.dk> <20130522101858.GH9714@kernel.dk> <OFABB32A79.2C0C3A51-ON80257B73.00423F23-80257B73.0043C1F5@uk.ibm.com> <20130522122525.GK9714@kernel.dk>
MIME-Version: 1.0
Subject: Re: output - aggregate read bandwitdh
From: Edoardo Comar <ECOMAR@uk.ibm.com>
Message-ID: <OF698EE77E.9C7A9E39-ON80257B73.00483C44-80257B73.0048DDBA@uk.ibm.com>
Date: Wed, 22 May 2013 14:15:43 +0100
Content-Type: text/plain; charset="US-ASCII"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> > this has fixed the read aggrb reported value to be unreasonably high
> > however the value is now significantly lower than 2.0.13  it's about 
1/2
> > while the write value is very comparable.
> > Please find the outputs below.
> 
> This is due to the change in thinktime, fixing the unreasonable
> latencies. Effectively it reduces your queue depth to what
> thinktime_blocks is set to, which is 1 by default. Even if set to the
> queue depth, you will still be completely draining the software queue
> for every N thinktime_blocks. I'm guessing your device has write caching
> enabled, hence the change is basically only apparent on reads. The
> writes queue up nicely on the hw side still.
> 
> -- 
> Jens Axboe
> 

Ok -  if I explicitly set the iodepth=1 in the job config file
then the results of the master fio-2.1-10-g4b20  and the old 2.0.13 are 
comparable.

Thanks again, great job, Jens
cheers
Edo

 
Unless stated otherwise above:
IBM United Kingdom Limited - Registered in England and Wales with number 
741598. 
Registered office: PO Box 41, North Harbour, Portsmouth, Hampshire PO6 3AU


