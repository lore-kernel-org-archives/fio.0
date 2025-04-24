Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3411A4C98
	for <fio@vger.kernel.org>; Thu, 24 Apr 2025 03:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745463658; cv=none; b=RI5SH9YQugT0mDrtljdPAfy1HfEKhEl7W5wny16hiWy29/TCb7ncVhJfuupNJCfms6CFydvnV6GwGFUvu5ewCmIjSghrmyFtApqw/m9Aa5+TIpzrzLw7setgCzg5f860WwwSp1zKLDDytOZmEB7ntG8/bQCBVlMEvUGgaU19glE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745463658; c=relaxed/simple;
	bh=No0tuxAb3ESylOUtiQ1M40Ug+0eIhyC7/4bqsGCGFf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GCquHYdGYMMpLqLgB7xOAQMAyO4xn7u1+ObvpzQYc4POXTfgAlC9jccJ82tAL07xB3IAV/5hLCMfVKUhXvWCFzb4SlffqnSU7k7OCIl3gmG1qEudLVPEe7I63HZioTpuJSWYetqA5e2aaFZdbO6A2SRLLUGzt4nZT8+74rkzsD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WVOqEISH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVOqEISH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9A6C4CEE2;
	Thu, 24 Apr 2025 03:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745463656;
	bh=No0tuxAb3ESylOUtiQ1M40Ug+0eIhyC7/4bqsGCGFf0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WVOqEISHWdw7lwoHqbzT+w2RaKsL/JHQfZjRS8qJubSIqJ5t08Q8V9MEJ4yf5WHmp
	 ypsBTyRbl8ppYA01RtDCa6deCBUJZgYlYMBIJwTmtBGcZxBt7E1DTzN6eFOKYsrGQc
	 0rMVfHZgMmlRYelhejMK924JuThO1t3CSKbwn6Zqf9r74RdGGhczHn/TfEdw3m80BF
	 muHYdNiktiruMtxwhIRBhHi98Zk3wPwFvrUfwQ5ubB130kg2ciYjkY5+umz5AZDEWO
	 dZF5uxaohI/Psf8egabqAZaZ6IIla1O5RtJf348MhIbRKudr3FPGCOUNe2Ti5D0E4e
	 NxnhEWGn6f3cw==
Message-ID: <e5c59cb4-4613-415b-a8df-9926bfecee64@kernel.org>
Date: Thu, 24 Apr 2025 12:00:54 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Performance variation in traditional HDDs?
To: Nick Neumann <nick@pcpartpicker.com>
Cc: fio@vger.kernel.org
References: <CADqNVTpRsQXDsW034A8SWeWEbpsAUcidWiKgpj+Xm74NYNPjQQ@mail.gmail.com>
 <faad816b-3683-43e6-a700-65eba76d9a0d@kernel.org>
 <CADqNVTrptG5b4Un=Q9Hqe5WPMTdcaCDtbjzR753j9YWorEBnxA@mail.gmail.com>
 <CADqNVTqM3se6L=qJUh5U3kwpWCCbuR3GjE+xQ+JCQVRL=t60OA@mail.gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CADqNVTqM3se6L=qJUh5U3kwpWCCbuR3GjE+xQ+JCQVRL=t60OA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/24/25 06:04, Nick Neumann wrote:
> Just a quick update on initial test results. We started with the two
> "identical" drives (https://pcpartpicker.com/product/BcQG3C) that
> showed the largest difference. Note these are SMR drives so we are
> careful to do an "ATA SECURITY ERASE" before running our benchmark.

So these are drive-managed SMR disks, right ?
All bets are off in terms on performance then. These drives behave like SSDs and
do a lot of internal "grabage collection" to handle the sequential write SMR
constraint. And even doing a purely sequential write workload to the disk does
not guarantee in-order deliveries of the writes to the disk, so that garbage
collection may be trigerring and changing the results. AHCI adapters are
notorious for *not* delivering commands in order...

> Previously we had these drives sitting vertically in 3d-printed trays
> during our benchmarking. We moved to benchmarking them mounted
> horizontally with screws and vibration dampening pads. They were
> mounted to a heavy metal "open air" style case. Drive 1 was
> benchmarked, then Drive 1 was removed and Drive 2 installed in the
> exact same location as Drive 1, and then Drive 2 was benchmarked.

Mounting drives vertically is fine. Plenty of enterprise high-density JBOD
enclosures use such mounting. Vibration dampening is still a requirement of course.

> We didn't see any real difference in results when changing to this
> traditional mounting. Drive 1 went from an average full-write
> throughput of 174.06MB/s to 174.08MB/s. Drive 2's average full write
> throughput stayed at exactly 157.88MB/s.
> 
> Looking at a graph of throughput over time for the
> differently-behaving but identical drives is really interesting:
> https://cdna.pcpartpicker.com/static/forever/images/content/13b2fa7e147ddd5359f5638b4efde7af.png

The general shape of the curve going down with higher LBAs is normal as an HDD
performance is higher at OD (outter diameter, more sectors per track) than ID
(inner diamters, shorter tracks so less sectors per revolution).
However, since these seems to be drive-managed SMR disks, there is no way to
tell how the HDD firmware is mapping LBAs to physical sectors. The noisy results
tend to indicate that there is a lot of HDD internal IOs going on.

> We're working on making sure our HDD mounting is adequate. Do you have
> any specific guidance/tips on what should be done? Is the goal of the
> mounting to prevent outside vibrations from affecting the drive,
> dissipating internal vibrations, or both? We use a number of identical
> 3U rackmount machines for our SSD benchmarking and would also like to
> leverage them for diving into this HDD issue in more depth, but they
> do not have traditional HDD mounting locations. So for now we are more
> slowly conducting experiments on one of our open-air dev benchmark
> machines, which has proper mounting locations.

I do not think this is a mounting issue. Drive-managed SMR and disk internal
state differences are more likely. I recommend you contact your drive vendor to
see if they can explain things. Generally, drive internal FW operation is not
public information though.

Another thing you may want to try is to do a full format of the drive before
benchmarking them. To make sure the LBA mapping is reset and consistant between
the drives.


-- 
Damien Le Moal
Western Digital Research
