Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13C730B565
	for <fio@vger.kernel.org>; Tue,  6 May 2025 02:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746498924; cv=none; b=lslK+p3dRg++pAKpJ2eRDFwt9frAUdThxKLtVGaKsNK5lr3rzdX18Y841Aa1/2LnlrKTrlKq4oFD84/vqNEywNpgWqmK8PLJpmntMHSIaWXKR0QOKHKr0yKg+d7KlqCkUHsHr1nHPvdYwhV5t7MT3be1M5UAOlKZiXkoqoL53+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746498924; c=relaxed/simple;
	bh=pAeF5iWw2hrgDs39/D14BDMut7ajPl/CZI2sC+8queg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P+g7S27W8lozhlmF2m/XHZb9SxqKUmK1bNXunHpEj8EXzL+MpohWxmVGLYUeXa0SQsmq+kDKJXGf4uo4Xvu/hiXjOdoOY7jUIU5rqL5DbbcxxVSlPD+gEHd+Xz8b040N2Tdlk7GcSdtU5sFhPmRjznXObasTeXQCcEvSRDaXHUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FL6AWLAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FL6AWLAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EF5C4CEE4;
	Tue,  6 May 2025 02:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746498924;
	bh=pAeF5iWw2hrgDs39/D14BDMut7ajPl/CZI2sC+8queg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FL6AWLAwCIaF54urVueXK72WFhmU+cRODkiKpgjaT9iWK1eqdDfcyp58eVw50eUMw
	 mvVDPgU2YB/PlsNI6nJGHQFnv1rqY250wluFH12kk8j6l7/1Aq4qVdPaQyjgd/mnBy
	 Qlm3ULOd3iug/LPDe8HRfxVNgqCqHCF8eptenFMzGADoK/wOGuRqqSm0LlfOkOy/xc
	 rkAANSLxiiQKvvaz9dn7EcaIlMISTuRPlki4DD+HqOE+lx7Bp44v4ZvEU8lQGFszdV
	 S0DTPpNqGkfgxY9MYa4aYH8HdijGUnu8uSw7miLbZ2sV2bezj4cIsNUi3Nlj7AVy8L
	 hpiderzpy4pUA==
Message-ID: <de053229-7744-4711-b311-185bff052642@kernel.org>
Date: Tue, 6 May 2025 11:35:22 +0900
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
 <e5c59cb4-4613-415b-a8df-9926bfecee64@kernel.org>
 <CADqNVTpdEgAgp3tvCEVGq1trdJwMO=EVZ5bwBQppWVfaBUOeFw@mail.gmail.com>
 <CADqNVTr=172CGUwUGUzDHtONV5YWw2hirKXzebmb0rp2YdDTLQ@mail.gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CADqNVTr=172CGUwUGUzDHtONV5YWw2hirKXzebmb0rp2YdDTLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/3/25 04:33, Nick Neumann wrote:
> Here's another CMR drive (https://pcpartpicker.com/product/6FQcCJ).
> Here, two identical drives with same model number and firmware show
> about a 10% difference in performance.
> 
> Looking at the average full drive write speed we saw the following
> results in MB/s:
> 
> Drive 1: 153.86, 153.86, 153.86
> Drive 2: 140.63, 140.64, 140.65
> 
> Again, each individual drive is incredibly consistent in its
> performance. But drive 1 is over 9% faster than drive 2. And the
> graphs of bandwidth over time for a full write are markedly different:
> 
> https://cdna.pcpartpicker.com/static/forever/images/content/684ce1fea2858681575fb7666b8b987f.png
> 
> Reporting benchmarked performance for HDDs is problematic when there
> is variation like this between two of the same drive.

I am not sure what the specsheet for this drive claims is the maximum
performance and if that checks out with your tests.

But some variation from disk to disk happens because of the variations between
heads & media that happen at manufacturing time (head SNR differences etc). How
much variation is allowed completely depends on the design manufacturing
tolerances. For enterprise class drives, this is generally tight (e.g. +- 5%),
but for consumer drives this tolerance may be relaxed, which seems to be the
case for this drive as you are seeing nearly a 10% difference.

This is a general comment. The tolerances applied completely depend on the drive
vendor and disk model. I cannot comment on a specific drive model.


-- 
Damien Le Moal
Western Digital Research
