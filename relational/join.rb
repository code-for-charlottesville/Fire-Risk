# join all tables (except master_address_table) on ParcelNumber and GPIN
# GeoParcelIdentificationNumber == GPIN
#
# For join keys see
# https://widget.charlottesville.org/gis/opendata/OpenDataPortal_DataGuide_Parcel_Real%20Estate%20Assessment%20Data.pdf
#
# for SQL, see below
# this is acceptably performant without indexes
def all_tables
  join_ds = db[:parcel_area_details].
    left_join(:real_estate_commercial_details, :ParcelNumber => :ParcelNumber).
    left_join(:real_estate_residential_details, :ParcelNumber => :ParcelNumber).
    left_join(
      :parcel_boundary_area,
        Sequel[:parcel_area_details][:GeoParcelIdentificationNumber] =>
        Sequel[:parcel_boundary_area][:GPIN])

  # Fetch all tables involved in the join.
  # Dependent on Sequel internal AST structure. Which is fairly stable so should be OK
  tbls = [*join_ds.opts[:from], *join_ds.opts[:join].map(&:table)]

  # rename each field to a unique name based on its source table
  # TODO could shorten table names to eg pad recd rerd pba
  fields = tbls.flat_map do |tbl|
    db[tbl].columns.map do |col|
      Sequel[tbl][col].as(:"#{tbl}_#{col}")
    end
  end

  join_ds.select(*fields)
end

=begin
And this is the generated sql

SELECT
  "parcel_area_details"."OBJECTID" AS "parcel_area_details_OBJECTID"
, "parcel_area_details"."Assessment"AS"parcel_area_details_Assessment"
, "parcel_area_details"."FileType"AS"parcel_area_details_FileType"
, "parcel_area_details"."GeoParcelIdentificationNumber"AS"parcel_area_details_GeoParcelIdentificationNumber"
, "parcel_area_details"."IsMultiParcelPolygon"AS"parcel_area_details_IsMultiParcelPolygon"
, "parcel_area_details"."Label"AS"parcel_area_details_Label"
, "parcel_area_details"."LegalDescription"AS"parcel_area_details_LegalDescription"
, "parcel_area_details"."LotSquareFeet"AS"parcel_area_details_LotSquareFeet"
, "parcel_area_details"."MapPage"AS"parcel_area_details_MapPage"
, "parcel_area_details"."ModifiedDate"AS"parcel_area_details_ModifiedDate"
, "parcel_area_details"."OwnerName"AS"parcel_area_details_OwnerName"
, "parcel_area_details"."OwnerAddress"AS"parcel_area_details_OwnerAddress"
, "parcel_area_details"."OwnerCityState"AS"parcel_area_details_OwnerCityState"
, "parcel_area_details"."OwnerZipCode"AS"parcel_area_details_OwnerZipCode"
, "parcel_area_details"."ParcelNumber"AS"parcel_area_details_ParcelNumber"
, "parcel_area_details"."StreetName"AS"parcel_area_details_StreetName"
, "parcel_area_details"."StreetNumber"AS"parcel_area_details_StreetNumber"
, "parcel_area_details"."TaxYear"AS"parcel_area_details_TaxYear"
, "parcel_area_details"."Text"AS"parcel_area_details_Text"
, "parcel_area_details"."Unit"AS"parcel_area_details_Unit"
, "parcel_area_details"."Zoning"AS"parcel_area_details_Zoning"
, "parcel_area_details"."ESRI_OID"AS"parcel_area_details_ESRI_OID"
, "parcel_area_details"."geometry"AS"parcel_area_details_geometry"
, "parcel_boundary_area"."GPIN"AS"parcel_boundary_area_GPIN"
, "parcel_boundary_area"."OBJECTID"AS"parcel_boundary_area_OBJECTID"
, "parcel_boundary_area"."geometry"AS"parcel_boundary_area_geometry"
, "real_estate_commercial_details"."RecordID_Int"AS"real_estate_commercial_details_RecordID_Int"
, "real_estate_commercial_details"."ParcelNumber"AS"real_estate_commercial_details_ParcelNumber"
, "real_estate_commercial_details"."UseCode"AS"real_estate_commercial_details_UseCode"
, "real_estate_commercial_details"."YearBuilt"AS"real_estate_commercial_details_YearBuilt"
, "real_estate_commercial_details"."GrossArea"AS"real_estate_commercial_details_GrossArea"
, "real_estate_commercial_details"."StoryHeight"AS"real_estate_commercial_details_StoryHeight"
, "real_estate_commercial_details"."NumberOfStories"AS"real_estate_commercial_details_NumberOfStories"
, "real_estate_commercial_details"."StreetName"AS"real_estate_commercial_details_StreetName"
, "real_estate_commercial_details"."StreetNumber"AS"real_estate_commercial_details_StreetNumber"
, "real_estate_commercial_details"."Unit"AS"real_estate_commercial_details_Unit"
, "real_estate_residential_details"."RecordID_Int"AS"real_estate_residential_details_RecordID_Int"
, "real_estate_residential_details"."ParcelNumber"AS"real_estate_residential_details_ParcelNumber"
, "real_estate_residential_details"."StreetNumber"AS"real_estate_residential_details_StreetNumber"
, "real_estate_residential_details"."StreetName"AS"real_estate_residential_details_StreetName"
, "real_estate_residential_details"."Unit"AS"real_estate_residential_details_Unit"
, "real_estate_residential_details"."UseCode"AS"real_estate_residential_details_UseCode"
, "real_estate_residential_details"."Style"AS"real_estate_residential_details_Style"
, "real_estate_residential_details"."Grade"AS"real_estate_residential_details_Grade"
, "real_estate_residential_details"."Roof"AS"real_estate_residential_details_Roof"
, "real_estate_residential_details"."Flooring"AS"real_estate_residential_details_Flooring"
, "real_estate_residential_details"."Heating"AS"real_estate_residential_details_Heating"
, "real_estate_residential_details"."Fireplace"AS"real_estate_residential_details_Fireplace"
, "real_estate_residential_details"."YearBuilt"AS"real_estate_residential_details_YearBuilt"
, "real_estate_residential_details"."TotalRooms"AS"real_estate_residential_details_TotalRooms"
, "real_estate_residential_details"."Bedrooms"AS"real_estate_residential_details_Bedrooms"
, "real_estate_residential_details"."HalfBathrooms"AS"real_estate_residential_details_HalfBathrooms"
, "real_estate_residential_details"."FullBathrooms"AS"real_estate_residential_details_FullBathrooms"
, "real_estate_residential_details"."BasementGarage"AS"real_estate_residential_details_BasementGarage"
, "real_estate_residential_details"."Basement"AS"real_estate_residential_details_Basement"
, "real_estate_residential_details"."FinishedBasement"AS"real_estate_residential_details_FinishedBasement"
, "real_estate_residential_details"."BasementType"AS"real_estate_residential_details_BasementType"
, "real_estate_residential_details"."ExternalWalls"AS"real_estate_residential_details_ExternalWalls"
, "real_estate_residential_details"."NumberOfStories"AS"real_estate_residential_details_NumberOfStories"
, "real_estate_residential_details"."SquareFootageFinishedLiving"AS"real_estate_residential_details_SquareFootageFinishedLiving"
FROM "parcel_area_details"
LEFT JOIN "real_estate_commercial_details"
 ON ("real_estate_commercial_details"."ParcelNumber"="parcel_area_details"."ParcelNumber")
LEFT JOIN "real_estate_residential_details"
 ON ("real_estate_residential_details"."ParcelNumber"="real_estate_commercial_details"."ParcelNumber")
LEFT JOIN "parcel_boundary_area"
 ON ("parcel_area_details"."GeoParcelIdentificationNumber"="parcel_boundary_area"."GPIN")
;
=end
