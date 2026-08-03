Received: from newman.cs.utexas.edu (newman.cs.utexas.edu [128.83.139.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD77C42BEBA
	for <fio@vger.kernel.org>; Mon,  3 Aug 2026 20:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.83.139.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785790216; cv=none; b=RSTJ+C4RMymy9VS/8JxogqDqSId2+1YKgRK6lOa2tB0G794zgDLLUvjB7xcGAUjj6YRLWj1kBm1WrDC+kIk8VLYNVIzHNr3+dLwEhha5Q17pqhTu2pMLG5FaVWSwFYU70AEYONqXeyprjLDyOQYsXaGOnwAVVVDPdSIrILjfBv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785790216; c=relaxed/simple;
	bh=/wCazf8KRzXFqWjMTV3zWrYTndCL9tsbKTMLOzDz2Bo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T5EPgV2qkIN876tpGaaUanZ5wwiv1bv0Z3eyfOlimbuGLn+0l0zy3M41TwUtyj+aafE72lC2yw9Ev5mdBvkrLzMg3s8UVkdcGwQQje3D0DDLGTtjfDixlfMJJh6sLD/RiOEWdDf3OzK4t1PpEkTL2kqQSF6EyR1JcoOdXitNz70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.utexas.edu; spf=pass smtp.mailfrom=cs.utexas.edu; dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b=nlF+eeb4; arc=none smtp.client-ip=128.83.139.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.utexas.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.utexas.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b="nlF+eeb4"
X-AuthUser: pgoetz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
	s=default; t=1785790211;
	bh=/wCazf8KRzXFqWjMTV3zWrYTndCL9tsbKTMLOzDz2Bo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nlF+eeb44iIVjHyRQbOrnMSjJZcklakqaSypvvhBpk1ikrfcQ476eKEZ0aSQkJYd8
	 9Pqh0Y2sF6tk+K7NXoktYq5lO0SCZmCeyQnQU3OWVc5CD7xRGrR7V0utyGKnjWdW5A
	 zKjnIMYYpnz7voocrWHUGuP/W6fwMd5dZ566VfH8=
Received: from [128.83.120.185] (texas-tea.cs.utexas.edu [128.83.120.185])
	(authenticated bits=0)
	by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id 673KoBLu047182
	(version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 3 Aug 2026 15:50:11 -0500
Message-ID: <c9a0d779-adfd-47da-83a3-474b3aa4cfd1@cs.utexas.edu>
Date: Mon, 3 Aug 2026 15:50:10 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Consistent core dump of fio 3.36
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio@vger.kernel.org
References: <984fc666-48fe-4212-96e7-6740a270d755@cs.utexas.edu>
 <CALjAwxjRNkYidXgnhLH8O-qoBaWK5K-j4v=eQjCKgOT0fFZ4kg@mail.gmail.com>
Content-Language: en-US
From: Patrick Goetz <pgoetz@cs.utexas.edu>
In-Reply-To: <CALjAwxjRNkYidXgnhLH8O-qoBaWK5K-j4v=eQjCKgOT0fFZ4kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Mon, 03 Aug 2026 15:50:11 -0500 (CDT)
X-Virus-Scanned: clamav-milter 0.103.8 at newman
X-Virus-Status: Clean



On 8/3/26 14:59, Sitsofe Wheeler wrote:
> 
>> Is there something wrong with my syntax?
> 
> I think your syntax is fine and at first glance it just looks like
> you're asking for a lot of files. Did you try fio's suggestion to
> tweak --alloc-size


Thanks -- that was the issue. Increasing the --alloc-size to 100000 
solved the problem.


