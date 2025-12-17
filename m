Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505F1155C82
	for <fio@vger.kernel.org>; Wed, 17 Dec 2025 22:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766012112; cv=none; b=J3DlFNsD0jJmS0M9Piw4A36mIXDq35xWjV33ajSFTZI6lEZ/jO5xEGRdfRtERIrswuPfuM1APcwwmJb7OwxBZ2YVCRYBY6ZjFAy29CHbhVd+7m0fs3pNobsdnWaJkYQ5jMw6lnDa6yiFRQfNCzCWsPlb2AOM7aqZ8ItXdfhC/9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766012112; c=relaxed/simple;
	bh=uJ2s3Z2FOO/EUorU4vm9PNnW/lF54xAWYR3UzHNeJzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fj/1QNc9zvVkBRhpFau6jy2dvmHeUm4yjJQi83jqLBqBqzYFNZ4DN/OPOFdyb+XDXUn8YqGM0DlSnEqn5xu+Lb0olHoP6t1KRcgJko33q8hm6r+6PIxwSp0keoT4I4I1KNBTxgyuY2wA9kVjtzrzt7NJwQpdry20RxO00w4iQiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QSOsC1xJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QSOsC1xJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333D6C4CEF5;
	Wed, 17 Dec 2025 22:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766012111;
	bh=uJ2s3Z2FOO/EUorU4vm9PNnW/lF54xAWYR3UzHNeJzU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QSOsC1xJbB4cVebpfgoyEKtDTPL2ptq7WZ/woFLeHB85n5OwL3Ub5RFsaDGm/2r74
	 3dPJgiJoRq0ihMVQ6GFH7TO8GbWv+H7TrRqej+CURAGRB4lUQFoO2nQwZGAscp9qz/
	 eVLYeduTdTLKpBgwMef8n2b+vi0SS+jP6uEFHEidd8wUY8Jnnyx1RM2z+cwljrcmDj
	 U6Bpq7V17oDHvf2rbNF9C8fKjyrJ8bd4kE/acDAWua+jVEDusoYLqko8WA9X4Y6rmc
	 3f9c0t7s+jdeUQeS9cZYSIRA1FC9+YLFrUI2wfqJlUPszokUp4hIOhr0dO3MF8Pl0y
	 1syRg/vN2WCRg==
Message-ID: <95e9ba19-2753-4cda-b4e0-748c6687f317@kernel.org>
Date: Thu, 18 Dec 2025 07:55:09 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] eta: Use in_ramp_period() instead of opencoding it
To: Jan Kara <jack@suse.cz>, fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20251217160217.15533-1-jack@suse.cz>
 <20251217161722.6357-3-jack@suse.cz>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251217161722.6357-3-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/18/25 01:17, Jan Kara wrote:
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
