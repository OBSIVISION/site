/// The page's words, as set in Figma. `web/index.html` carries the same copy
/// for crawlers and readers without script; keep the two in step.
abstract final class ObsCopy {
  static const wordmark = 'OBSIVISION';
  static const subtitle = 'TECH FOUNDRY';
  static const motto = 'IMAGINE. DESIGN. DEVELOP.';

  /// Three paragraphs; the second and third are set apart by an empty line,
  /// the first two are not.
  static const body =
      'Most things worth building are invisible at first. A habit of '
      'thought. A way of looking. The patience to stay with a problem until '
      'it gives up its shape.\n'
      'To create is, in the end, to discover. Every idea given form reveals '
      'something that was always there, waiting to be seen — and slips, each '
      'time, a little further past the limits of matter. Engineering, done '
      'honestly, is an art like any other. There is also a quiet kind of '
      'ambition that does not announce itself. It reads widely, thinks '
      'slowly, and builds with the long view in mind, knowing that clarity '
      'is rarely given and almost always earned.\n'
      '\n'
      'Every true work asks something of its maker — the readiness to be '
      'consumed by it, at least for a while. Difficulty, it turns out, is not '
      'the enemy of clarity. It is often where clarity begins. To see a '
      'little further, and build a little truer — that is the whole of the '
      'vision.';
}
