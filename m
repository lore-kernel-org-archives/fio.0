Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65D5157A72
	for <fio@vger.kernel.org>; Fri,  6 Sep 2024 23:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725665366; cv=none; b=A0Y3pD4XyAID11ubIJC+IGK6K7tX0Fi9auLFGLg4q36tkXMtvHXQ6BPAtUirFuIF2GhDV4/zKQUsKlaVq3KoHwda3/TyfxyLJNQ6ZLddHmpe5iKauE1Hp374898xaIsHPjMPdLv+ui4coA3rfZMAHjUFqepv84WzrlAsmNfVKQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725665366; c=relaxed/simple;
	bh=xeNcPCNLGdMnsv28/0g2/79KUbLqU6pnCCY+3v1ej0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCN/5SZNSNkL0TzDYW5gb73HBU2FgPNcnkZOj76eQb40EqcIEUkgxe3Pis/VoE7PBa+7DdHnXvDWxqoV84aip5KeZHamhFDCKjhiyiYo94ovgm+hHTlJ2/P44Rof4kzkz3blq8atBhtkA/1Rn4s38Jucbp2KpcXtp+2cNaw02gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EpQFg3ah; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EpQFg3ah"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VNVlzNxWmPrIz9Xs9/rEWAlFcJETk7gLBfdtpFaLe0w=; b=EpQFg3ahkOeQBHLXALwrCElWZi
	AW2098iKo2sYH06CgUu6V5wHf4MJVAnSleB2O0LlmyeY0JEu2ydg2ZE++fuVrrYlTEqPePfnNJG4v
	gOBjygVBGiDTRWVrkPVe07jcQGUVyMIplHdizXGWTlyc/U15xph2C0OKNwhbKgWjzH6Sz13bvxMiG
	q3A4IKYOPTNkqixNjCpggXCx5SLHHbQ6VgSiBp686QS2Pbs2uF1Mah2j/vlflEI9WwMG6aM4BCHMn
	0p6Cc0cWnfBT69KAs2Rjfs/cGyfxOlCsPiRKu26k8lfX41EuKdHhr1DbXPjEh26/BDDtpC06l/+Xo
	7HTAHfag==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1smiOL-0000000Ds6u-0kVx;
	Fri, 06 Sep 2024 23:29:25 +0000
Date: Fri, 6 Sep 2024 16:29:25 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: John Garry <john.g.garry@oracle.com>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org, axboe@kernel.dk, martin.petersen@oracle.com,
	djwong@kernel.org, Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Dan Helmick <dan.helmick@samsung.com>
Subject: Re: [PATCH 0/7] fio: atomic write support
Message-ID: <ZtuQVTC4MwdzRDsy@bombadil.infradead.org>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
 <Ztl72OINsWHeq4pz@bombadil.infradead.org>
 <316ec2a1-52f8-49e5-9645-f93f3e7c5383@oracle.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <316ec2a1-52f8-49e5-9645-f93f3e7c5383@oracle.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, Sep 06, 2024 at 04:22:24PM +0100, John Garry wrote:
> However, if we have multiple jobs, they may overwrite blocks from other jobs
> - fio warns us about that. As such, in verify mode, the read sequence number
> may not match was we were expecting with multiple jobs running.

Is that a generic bug in fio?

  Luis
