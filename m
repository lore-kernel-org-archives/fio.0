Received: from newman.cs.utexas.edu (newman.cs.utexas.edu [128.83.139.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A059012C81F
	for <fio@vger.kernel.org>; Thu,  4 Apr 2024 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.83.139.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712247505; cv=none; b=Wz02UMPDDrQpF5KyG5hfhD+vfTGAJRcfeUmPO9OxMog9dRgB3demqYP+0kaXRg4JnzPpRcDi0KD5oel5A4HWG853Tv4l1+qp5QjVIq0dXDMbiemruLytWnJGWp819aN6MReT5w7UxTSKBO7se1l6p564vP+St3LQmI4m5+twuck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712247505; c=relaxed/simple;
	bh=x/fYEZqDWsrt1Y0zI9CeWEYN3GG3iGe88veFSeqqwOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gb7P5UbH3sMfwGfmq2j8AYfemlTZ8BareSPbcZQXtCAVL9KU89XrY6TCKxe94EQtRnKZ9HpAHsMfkS6d/YwrvkOa1x1cXwcN4FDuZU8h1yxbHI6iegKWLSkWBzsr9d4kmaFsLZRiXXD4yZIMMkPdyQrjf0LBUKo8X4PAtYpwQBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.utexas.edu; spf=pass smtp.mailfrom=cs.utexas.edu; dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b=gaRTtpDm; arc=none smtp.client-ip=128.83.139.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.utexas.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.utexas.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b="gaRTtpDm"
X-AuthUser: pgoetz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
	s=default; t=1712247482;
	bh=x/fYEZqDWsrt1Y0zI9CeWEYN3GG3iGe88veFSeqqwOs=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=gaRTtpDmo9pQxWbO2srMf16ej2BbgDpdPiZ0YXpWtpD+Zfb8WG/LQDpVyaAfD1BRF
	 h5UWPrHjOGw8+M7cPRZ7YYbt7WzPwFT65PO8RpIkzG6wdpovxZMCOUq4JHaBdXDwC+
	 ne5uOc4sOG1A/JMuCUWtCiUvM3xv2LmoN3nw7Xgs=
Received: from [128.83.120.185] (texas-tea.cs.utexas.edu [128.83.120.185])
	(authenticated bits=0)
	by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id 434GI1Xv038511
	(version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 4 Apr 2024 11:18:01 -0500
Message-ID: <213da342-d37c-49be-93f8-a36c9bbef06e@cs.utexas.edu>
Date: Thu, 4 Apr 2024 11:18:01 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: help understanding the output of fio
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, Felix Rubio <felix@kngnt.org>,
        fio@vger.kernel.org
References: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org>
 <2494cb75-e0ff-41fe-ad4c-73f383a0c704@cs.utexas.edu>
 <a3415a4de55f178b06c3451fdbe43e08@kngnt.org>
 <cfbf631e-5783-40a1-b577-9716c3cdc955@kernel.org>
From: Patrick Goetz <pgoetz@cs.utexas.edu>
In-Reply-To: <cfbf631e-5783-40a1-b577-9716c3cdc955@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Thu, 04 Apr 2024 11:18:02 -0500 (CDT)
X-Virus-Scanned: clamav-milter 0.103.8 at newman
X-Virus-Status: Clean

On 4/3/24 23:28, Damien Le Moal wrote:
> 
> Also, there is no filename= option here. Are you running this workload on the
> ZFS file system writing to a file ? Or ar you running this against the SSD block
> device file ?
> 

If he ran this fio test against the SSD block device, wouldn't that blow 
up his zpool?

I read through the entirety of 
https://fio.readthedocs.io/en/latest/fio_doc.html and still feel 
completely clueless about many details. It kind of feels like you need a 
good grasp of how all this is implemented in the kernel to make sense of 
it. Does anyone have any tips for what to read in order to be able to 
master the fio documentation?



