class Feature < ActiveRecord::Base
  attr_accessible :name,:description,:status,:order
  has_many :feature_pricing_plans

  scope :is_active, where(:status => true)
  def self.get_all_feature
    
    all_features = self.is_active.order('"order"')
    return_data = {
      "aaData" => [],
      "iTotalDisplayRecords" => all_features.size
    }
    all_features.each do |feature|
      return_data["aaData"] << [
        feature.name,
        "",
        feature.id
      ]
    end
    return_data
  end  	
  def self.generate_static_data
    f1 = Feature.create(:name =>I18n.t("features.feature1"),:description =>"",:order =>0,:status =>true)
    f2 = Feature.create(:name =>I18n.t("features.feature2"),:description =>"",:order =>0,:status =>true)
    f3 = Feature.create(:name =>I18n.t("features.feature3"),:description =>"",:order =>0,:status =>true)
    f4 = Feature.create(:name =>I18n.t("features.feature4"),:description =>"",:order =>0,:status =>true)
    f5 = Feature.create(:name =>I18n.t("features.feature5"),:description =>"",:order =>0,:status =>true)
    f6 = Feature.create(:name =>I18n.t("features.feature6"),:description =>"",:order =>0,:status =>true)
    f7 = Feature.create(:name =>I18n.t("features.feature7"),:description =>"",:order =>0,:status =>true)
    f8 = Feature.create(:name =>I18n.t("features.feature8"),:description =>"",:order =>0,:status =>true)
    f9 = Feature.create(:name =>I18n.t("features.feature9"),:description =>"",:order =>0,:status =>true)
    f10 = Feature.create(:name =>I18n.t("features.feature10"),:description =>"",:order =>0,:status =>true)
    f11 = Feature.create(:name =>I18n.t("features.feature11"),:description =>"",:order =>0,:status =>true)
    f12 = Feature.create(:name =>I18n.t("features.feature12"),:description =>"",:order =>0,:status =>true)
    f13 = Feature.create(:name =>I18n.t("features.feature13"),:description =>"",:order =>0,:status =>true)
    f14 = Feature.create(:name =>I18n.t("features.feature14"),:description =>"",:order =>0,:status =>true)
    f15 = Feature.create(:name =>I18n.t("features.feature15"),:description =>"",:order =>0,:status =>true)
    f16 = Feature.create(:name =>I18n.t("features.feature16"),:description =>"",:order =>0,:status =>true)
    f17 = Feature.create(:name =>I18n.t("features.feature17"),:description =>"",:order =>0,:status =>true)
    f18 = Feature.create(:name =>I18n.t("features.feature18"),:description =>"",:order =>0,:status =>true)
    f19 = Feature.create(:name =>I18n.t("features.feature19"),:description =>"",:order =>0,:status =>true)

  end
end
