Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0F633A709
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 08:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772179949; cv=none; b=uY+kXaYBigxgGL/2hi9NC/xdAisx+y5kbBMfTGPOUjFIJGGavKzxKJyLpa5glfSxJMM+Ka2JzPF1tU7wYHjjnPQ4uBvAj6Tqi3btWzxT7dsReooDnu6EcduOtN/cO0mjwFNOYiNJbzLvAmcBpR13EaZVMGRP/e7s6UUefYbHAgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772179949; c=relaxed/simple;
	bh=2PWlhcYb7GQsYeInq+6kQDIxN9gpIpAltS//huoSak8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=I7LtPgP7/LROIoWJtP2DReE9hvy3UKADhsdzfphtohxBpgTunSaazGOsr6zqfDje+yJXOOjUhqwFENDbVqBDLK/2nzq9krzHw6hpIiyiIvGLvLdhwNJRVpZvlzj6Q/P+gWJC6LUBtlNTOEdd2gSgBg3CDWMTNaPg4dxJWMDgCts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jb397MHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jb397MHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A215C116C6;
	Fri, 27 Feb 2026 08:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772179948;
	bh=2PWlhcYb7GQsYeInq+6kQDIxN9gpIpAltS//huoSak8=;
	h=From:To:Subject:Date:From;
	b=jb397MHtbzASOfreibHiXgZWNAHbG7eU58w9V1TXO5+qIycEu7y4f9EPeX1+DsyXq
	 vJC7lIeCGKZdbbhrJ3bakK+rwNzrE5FtyemMWMNIx8d9WrhXzY0i+HPSSSBxqonr4W
	 SHlbR8mE49sy//MiXxIsA6Ek56r9xS2de/hfud5En9nnjuMMp63Qj8W7guoYEpyChz
	 w/HuwrZGcmLze4j7rPFG0lxvOV5xVUIitB9sgxGRNiVqsDCzHfU8me90eHCVNvFQY4
	 K/LnMmFYJrmJNtVeQyj02YcJQV2m1zglmn003jm7lyhyhqxFmM2JAuvmGBx+lROXlp
	 pv3dvKiljP+yg==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v4 0/8] Introduce the end_syncfs option
Date: Fri, 27 Feb 2026 17:07:03 +0900
Message-ID: <20260227080712.2422380-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jens, Vincent,

This patch series introduces the end_syncfs option and adds support for
it to the main IO engines that can handle regular files.
This new option improves the precision of file system benchmarks when a
large number of files are being handled.

Changes from v3:
 - Fix compilation errors with Windows/cygwin: dirname() and dirfd()
   functions do not exist apparently, so expand the scope of the
   CONFIG_SYNCFS conditional code.

Changes from v2:
 - Reworked patch 1 to build a list of file system mounts per job and
   have the end_syncfs option issue syncfs() call for eacho mounted file
   system when a job write stage completes.
 - Added patch 2 to 7 to support this new option in hte sync, libaio,
   io_uring, fallocate, fileoperations, ftruncate and posixaio IO
   engines.

Damien Le Moal (8):
  fio: introduce the end_syncfs option
  engines: sync: add support for DDIR_SYNCFS
  engines: libaio: add support for DDIR_SYNCFS
  engines: io_uring: add support for DDIR_SYNCFS
  engines: fallocate: add support for DDIR_SYNCFS
  engines: fileoperations: add support for DDIR_SYNCFS
  engines: ftruncate: add support for DDIR_SYNCFS
  engines: posixaio: add support for DDIR_SYNCFS

 HOWTO.rst                |   9 ++-
 backend.c                |  63 +++++++++++++++----
 cconv.c                  |   2 +
 configure                |  26 ++++++++
 engines/falloc.c         |   4 +-
 engines/fileoperations.c |   8 +--
 engines/ftruncate.c      |   4 +-
 engines/io_uring.c       |  16 +++--
 engines/libaio.c         |   8 ++-
 engines/posixaio.c       |   8 ++-
 engines/sync.c           |  11 ++--
 file.h                   |  17 +++++
 filesetup.c              | 132 ++++++++++++++++++++++++++++++++++++---
 fio.1                    |   8 ++-
 fio.h                    |   1 +
 helpers.c                |   8 +++
 helpers.h                |   3 +
 init.c                   |   1 +
 io_ddir.h                |   3 +-
 io_u.c                   |   6 +-
 ioengines.c              |  10 ++-
 ioengines.h              |   4 ++
 options.c                |  19 ++++++
 server.h                 |   2 +-
 stat.c                   |   3 +-
 thread_options.h         |   5 +-
 zbd.c                    |   1 +
 27 files changed, 333 insertions(+), 49 deletions(-)

-- 
2.53.0

