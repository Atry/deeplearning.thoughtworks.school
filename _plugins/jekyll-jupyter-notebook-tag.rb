# This file is copied from https://github.com/red-data-tools/jekyll-jupyter-notebook
#
# Jekyll Jupyter Notebook plugin
# Copyright 2017 Kouhei Sutou <kou@clear-code.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "tmpdir"

module JekyllJupyterNotebook
  class Tag < Liquid::Tag
    Liquid::Template.register_tag("jupyter_notebook", self)

    def initialize(tag_name, markup, tokens)
      super
      @notebook_path = markup.strip
    end

    def syntax_example
      "{% #{@tag_name} filename.ipynb %}"
    end

    def render(context)
      notebook_path = File.join(context["site"]["source"],
                                context["page"]["dir"],
                                @notebook_path)
      Dir.mktmpdir do |output|
        system("jupyter",
               "nbconvert",
               "--execute",
               "--template", "basic",
               "--to", "html",
               "--output-dir", output,
               notebook_path)
        html_path = Dir.glob("#{output}/*.html").first
        File.read(html_path)
      end
    end
  end
end
