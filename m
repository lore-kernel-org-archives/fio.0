Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03D33090D7
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 06:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772172055; cv=none; b=MmWyy2iNctCNiqZD5+Z8MNYZ4AJpIhfN/7BFfKWlAmEoRmrROVfsPXrar9+1XZ3yLAvdtOWsTx9M5IsKvXRtSZEZmSOvrLisqL58bXnfQvE7wgPlU7HfxzvXI3bHBsRcIVqqvYNBiRK/yN68xVgDO5qlXu8hPPiLPLc7NU5HUZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772172055; c=relaxed/simple;
	bh=wy7pjXi1+4c12tTcX+q1ZXa8ZMUeH9XT39vFDN5NIec=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Ip3C+s/Degf65OmNPaiiEoCacMcVRgFyy5P+GCvFttb+Bu8qXitJSMDr3tUseg1+jDtY2GUXkKkoAvACKEYWHTSBXqjKzElpJ1GE4bcWgi1bd+JScUvEkDUWMJ8yz1IMo1V1QpghqgY+oxnyyOQBe+kooOk+H9n9kwbDxFmGtvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFpeYbcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFpeYbcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE487C116C6;
	Fri, 27 Feb 2026 06:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772172055;
	bh=wy7pjXi1+4c12tTcX+q1ZXa8ZMUeH9XT39vFDN5NIec=;
	h=From:To:Subject:Date:From;
	b=UFpeYbcWz8o7o/2Bfr4JBBr+W/30xJ0FwJ4RRfJ9IF6IXucz/8o5YqyUYMRmE0h2d
	 vousT3PGpjynZJaOMgFAZZ/KdsrB8qInqcuRRlmV4bDFURkPyqaEYejYd2WegW2gP0
	 mZWHloqo2tk7CsxFQleu85MbjPGUgw0gGwQz9iXa1WasEOFGop+YKC4O/82GnxhbBY
	 wT0VPhQydlpX0yBWHepcZcxNMdAHGgOpu4Co7fXDstH5+nHFLvw4yYbT5SEzrI3ijU
	 VHtauOFE4Nq8yrsRrb8CqAZf8MKUcwfu5IG9Skr0gTQiT94G+64CrCZ4fEabjDa27o
	 mANTMkUQqL6kg==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v3 0/8] Introduce the end_syncfs option
Date: Fri, 27 Feb 2026 14:55:30 +0900
Message-ID: <20260227055538.2334916-1-dlemoal@kernel.org>
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
 backend.c                |  59 ++++++++++++++----
 cconv.c                  |   2 +
 configure                |  21 +++++++
 engines/falloc.c         |   4 +-
 engines/fileoperations.c |   8 +--
 engines/ftruncate.c      |   4 +-
 engines/io_uring.c       |  16 +++--
 engines/libaio.c         |   8 ++-
 engines/posixaio.c       |   8 ++-
 engines/sync.c           |  11 ++--
 file.h                   |  15 +++++
 filesetup.c              | 129 ++++++++++++++++++++++++++++++++++++---
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
 27 files changed, 319 insertions(+), 49 deletions(-)

-- 
2.53.0

