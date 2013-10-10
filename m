Return-Path: <fio-owner@vger.kernel.org>
Received: from smtprelay0132.hostedemail.com ([216.40.44.132]:37610 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757552Ab3JJVSG (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 10 Oct 2013 17:18:06 -0400
Message-ID: <52571992.3020607@nellans.org>
Date: Thu, 10 Oct 2013 16:18:10 -0500
From: David Nellans <david@nellans.org>
MIME-Version: 1.0
Subject: Re: IO scheduler
References: <CAAAK+WXw_-gAJL9u9Bibvz=4aHVH2YYvgQRi2sMvekY6xDRR4A@mail.gmail.com> <52571453.4050101@nellans.org> <5257158A.2050707@enovance.com>
In-Reply-To: <5257158A.2050707@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: "Brian L." <brianclam@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>


> That's a little bit extreme but it insures the same OS & environment to
> be used over & over making all my tests much more comparable over time.
>
Thats a really good point - I guess I should also be a little more 
specific about how we achieved tight reproducibility.

We used dedicated machines with identical components, a fixed point 
within an OS distribution, a known bios revision/settings, and disabled 
any/all frequency/power scaling.  So while we ran the machines without 
any special tricks, the machine configurations and OS were very 
extremely locked down and identical except for a hostname.

Anytime we changed anything within the cluster configuration we 
quantified the change before rolling it out cluster wide since on more 
than one occasion we discovered even things like bios revisions would 
substantially affect PCIe based testing.


