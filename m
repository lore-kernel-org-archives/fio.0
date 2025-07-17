Received: from infra.glanzmann.de (infra.glanzmann.de [88.198.237.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F39263F5E
	for <fio@vger.kernel.org>; Thu, 17 Jul 2025 07:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.198.237.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752738738; cv=none; b=dI3wem/UHfEeNClKGn8iHD6l/1hRZ1AD1/6r5ad16A9CzFHzSJZMKmXFmJARMMTpn826gIwDwcGVpyeeiH/eJEn9ADt7tNqMKshMkWKaXEP3yc+UPZOaR93GPVWgqe0myhMcxwj1enELJqoR8a/n07B31ZRuERa9TiXa/FR3Vjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752738738; c=relaxed/simple;
	bh=ipifRzLcICTveJvPYB0iK4pTqonXMRglOTCsrqEHm1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUiP0Wyk9vF4QrfllsUlua4pwKN2rWoE9qhBA462Pak128ModErwbzcQQIZtaGXVvtodmthf266QjKANfgETzlUCWBuJGELZy8VqFrlR23MpM9fSXW9M43iFr7Htwb7HVMyonm55+ZhcwxWtHOb48EIEmyw7VQV7w+CVpcjjQns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=glanzmann.de; spf=pass smtp.mailfrom=glanzmann.de; dkim=pass (4096-bit key) header.d=glanzmann.de header.i=@glanzmann.de header.b=aeOo8LrL; arc=none smtp.client-ip=88.198.237.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=glanzmann.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=glanzmann.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=glanzmann.de header.i=@glanzmann.de header.b="aeOo8LrL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=glanzmann.de;
	s=infra26101010; t=1752738724;
	bh=YMxa/eqNJP2D4ZbxaufRFlTaTfWONCeJwM6jvZoiseI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aeOo8LrLTc61jczyNTqEZPMZ2QiRgfk4brx2wrX2JPpm0DfPFiy12MoUShnqa1gXC
	 S/ZeLJfGNJ0AEZvZB8YffH/NJ4RmO2KCsJ4Rgxh45TcI/NHlJf2P87oGdcmkGqWfiQ
	 YbGuabjq19a6Xtl73opNkTgs4hliNxVy7GaBo7IlJ3ChSURBcvHPTauu6XDXaFGTpL
	 ls72UoscyZrC3aH8fDtc/CVdPywdfif7m+Q3L2H2DuiiOOeZGA8ldLwI0L9K5cC+qf
	 K/YwdYtlPmXUMpO85hxd3Hl2jrkrMzh+piK/AsZtWKiMdUfyZ+obuxBijx3ieQWjOB
	 UXUIwLAV9NDJV4uTANO1tXjeKxLh3vnBBKQXvyd8p8UMT7PlUkQqXuU+f2wMH+KN4L
	 2G5wJxaQ9OqTtpE2dnPMcGmX6BwUBQOiy860H/UFo40dtbe69Ago0ocYJ3O3ij7WWM
	 umseWG5kuCFNlKXJIlNw1E1eBYnZTtEF8mVVWl1o+LkaEAANFL99pdMC4H4Ddcu4YO
	 YD2vZNX4luEovowalejLlUue7y0Opf3owzC8CBaZehUwdePAgHhMqX6i0Igwh4WDzF
	 5QvJdJUAlhcmDLhzAjlGhCGCQQRum8rqxE/yRvoCV/1AwfQw63+Kb30/Q+cbDvvT6W
	 Oo8sx33IveKziYMovug2UJ1I=
Received: by infra.glanzmann.de (Postfix, from userid 1000)
	id E459E7A800A9; Thu, 17 Jul 2025 09:52:04 +0200 (CEST)
Date: Thu, 17 Jul 2025 09:52:04 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio@vger.kernel.org
Subject: Re: Evenly distribute jobs and iodepth over a 1 TiB device so that
 every byte is written to in parallel
Message-ID: <aHirpCGIIZlhlVfs@glanzmann.de>
References: <aHXkeSsuqlIj2R64@glanzmann.de>
 <CALjAwxiPOrgYLj2oyOeupgtk2mr7L3xMVdZYLjyRavsPqj==Qg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALjAwxiPOrgYLj2oyOeupgtk2mr7L3xMVdZYLjyRavsPqj==Qg@mail.gmail.com>

Hello Sitsofe,

* Sitsofe Wheeler <sitsofe@gmail.com> [2025-07-15 22:44]:
> (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-scramble_buffers)
> which may be enough but you would have to check. The trick would be to
> see what happens with a single stream as that's easier to reason
> about.

I see, I stuck with refill_buffers because it was good enough.

> https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset_increment
> and size https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-size

Thank you that resolved my problem. I used the following command line:

fio --ioengine=libaio --refill_buffers --offset=0 --offset_increment=26G \
        --size=25G --ramp_time=2s --numjobs=80 --direct=1 --verify=0 \
        --randrepeat=0 --group_reporting  --filename /dev/nvme0n1 --name=1mhqd \
        --blocksize=1m --iodepth=3 --readwrite=write

> Do you get similar results in terms of space used with a single fio
> stream? Start small and then work your way up!

Yes, that works, but I also wanted to benchmark parallel performacne.
Also the single fio stream takes an hour while the parallel one only
takes 8,5 minutes.

> But perhaps you're thinking of device queue depths?

Yeah, that I was looking for Keith Bush answered me. The commands I was
looking for, are:

# How many IO queues are there:

ls -1 /sys/block/nvme0n1/mq/ | wc -l

# How large is each IO queue:

cat /sys/block/nvme0n1/queue/nr_requests

> Given you're running 40 jobs I'd be surprised if you can hit a depth
> of over 1000 per job (that would be over 65000 I/Os in total) without
> some serious tuning. You may want to look at
> /sys/block/[disk]/queue/nr_requests (see
> https://www.kernel.org/doc/Documentation/block/queue-sysfs.rst ) and
> /sys/block/[disk]/device/queue_depth but you may also find you run
> into libaio limits...

I could not. The netapp only has 8 * 128 queue depth, so now that I knew
the exact values I adopted the same.

Cheers,
        Thomas
