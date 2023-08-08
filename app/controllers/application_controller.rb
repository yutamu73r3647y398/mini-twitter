class ApplicationController < ActionController::Base
  # 親クラスであるApplicationコントローラにSessionヘルパーモジュールを読み込む
  include SessionsHelper
end
