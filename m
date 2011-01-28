Message-ID: <4D427E29.2010100@fusionio.com>
Date: Fri, 28 Jan 2011 09:28:25 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Recent changes
References: <20110125050003.F378B37A302@kernel.dk>	<4D41DEEA.8040608@austin.ibm.com> <20110127220606.000076a4@unknown>
In-Reply-To: <20110127220606.000076a4@unknown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>
Cc: Steven Pratt <slpratt@austin.ibm.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2011-01-27 23:06, Bruce Cran wrote:
> On Thu, 27 Jan 2011 15:08:58 -0600
> Steven Pratt <slpratt@austin.ibm.com> wrote:
> 
>> Jens, the nested else ifeq statements in the main Makfile blow up on
>> make versions prior to 3.81.  SLES10 still has 3.80.  Not a big deal
>> for me, but I work with some folks for which this is over their
>> heads.  Any chance we could revert back to a more compatible syntax?
> 
> Confirmed with make 3.75 on FreeBSD. The attached patch should fix it.

Thanks Bruce, I got things reinstated as I like the unified Makefile.
Should have waited a bit on that revert, but hey... At least it's good
now.

-- 
Jens Axboe


