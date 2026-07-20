final: prev: {
  nautilus = prev.nautilus.overrideAttrs (nprev: {
    buildInputs =
      nprev.buildInputs
      ++ (with prev.gst_all_1; [
        gst-plugins-bad
        gst-plugins-base
        gst-plugins-good
        gst-plugins-ugly
      ]);
  });
}
