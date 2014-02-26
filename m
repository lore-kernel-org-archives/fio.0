Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:43026
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751319AbaBZPs7 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 26 Feb 2014 10:48:59 -0500
From: "Lamkin, Eric" <Eric.Lamkin@lsi.com>
Subject: RE: fio replay
Date: Wed, 26 Feb 2014 15:48:54 +0000
Message-ID: <e7ef163bab6c4f72a53926e0ef9f5ffd@BN1PR07MB437.namprd07.prod.outlook.com>
References: <651fd21aaf304da0b24902febae3c345@BN1PR07MB437.namprd07.prod.outlook.com>
 <76F46F78-8F5A-45CF-BBCE-3ADC63AFF541@nellans.org>
 <934f861a97f2443aa35296c2d6d8c848@BN1PR07MB437.namprd07.prod.outlook.com>
 <20140226153017.GA31124@sucs.org>
In-Reply-To: <20140226153017.GA31124@sucs.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: David Nellans <david@nellans.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Sitsofe,

Good to know someone is getting replay to work.
Were you replaying on the same host where the blktrace was recorded?  I am not.
I'll try with no --iodepth command.  That is all I see different between your methodology and mine.

I would also like to know what the message - fio: file hash not empty on exit - means.

What is btreplay?  Does it allow device mapping if the traced devices have different names on the replay host?
Will btreplay run unconstrained by the original timings?

Thanks,
Eric
-----Original Message-----
From: Sitsofe Wheeler [mailto:sitsofe@yahoo.com] 
Sent: Wednesday, February 26, 2014 9:30 AM
To: Lamkin, Eric
Cc: David Nellans; fio@vger.kernel.org
Subject: Re: fio replay

Hi,

I've been using blktrace with fio by doing the following on Fedora 20 with a git version of fio (fio-2.1.5-16-g81fa):
blktrace -d /dev/sdd
blkparse sdd -O -d sdd.dump
fio --read_iolog=sdd.dump --ioengine=libaio --name=replay

Using iowatcher I can see that fio is hitting the same blocks that the blktrace recorded.

It is also worth noting that certain options like rate, rate_iops and bs do not seem to affect replay jobs. Additionally, fio does not seem able to replay a job with the same timings that it is was recorded with (it also seems to do so faster) whereas btreplay has no issue doing this (even reproducing similar depths to the original job).

The one minor issue that I see is this:

Run status group 0 (all jobs):
   READ: io=40549MB, aggrb=30919KB/s, minb=30919KB/s, maxb=30919KB/s, mint=1342918msec, maxt=1342918msec
  WRITE: io=40562MB, aggrb=30929KB/s, minb=30929KB/s, maxb=30929KB/s, mint=1342918msec, maxt=1342918msec
fio: file hash not empty on exit

Why is the file hash not empty on exit? This happens no matter what I do.

On Wed, Feb 26, 2014 at 02:23:27PM +0000, Lamkin, Eric wrote:
> 
> Thanks for responding.
> I sent the below out last week but didn't get a reply so thought I'd 
> try a simpler 'what works' tactic this morning.  As seen in the below 
> I'm using 2.0.10.
> 
> > On Feb 26, 2014, at 7:44 AM, "Lamkin, Eric" <Eric.Lamkin@lsi.com> wrote:
> > 
> > Is there a version of fio where replay works with a Linux blktrace?
> > 
> anything within the last few years should play them back just fine, is 
> it broken in a specific version you're trying?

--
Sitsofe | http://sucs.org/~sits/

